import 'package:bolgelerim_app/constants/CustomSnackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/AddressModel.dart';
import '../services/AddressDatabase.dart';

class HomePageViewModel extends ChangeNotifier {
  List<AddressModel> _allAddress = [];
  List<AddressModel> get allAddress => _allAddress;  // Getter kullanmak

  AddressDatabase db = AddressDatabase.instance;

  // Veri çekme fonksiyonu
  Future<void> getAllAddress() async {
    try {
      _allAddress = await db.readAllAddresses();
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      _allAddress = []; // Eğer veri çekilemiyorsa, boş liste döndür
    }
    notifyListeners(); // Veriyi çektikten sonra UI'yi güncelle
  }

  // Adres silme fonksiyonu
  Future<void> deleteAddress(int id) async {
    try {
      await db.deleteAddress(id);  // Adresi veritabanından sil
      // Adres silindikten sonra listeyi güncelle
      _allAddress = await db.readAllAddresses();  // Listeyi tekrar yükle
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      print(e.toString());
    }
    notifyListeners(); // UI'yi güncelle
  }

  // Adres silme fonksiyonu
  Future<void> deleteAllAddress() async {
    try {
      await db.deleteAllAddress();  // Tüm adresleri veritabanından sil
      _allAddress.clear();  // Listeyi sıfırla
    } catch (e) {
      print(e.toString());
    }
    notifyListeners(); // UI'yi güncelle
  }

  // Google Maps  açmak için
  Future<void> launchMapsUrl(LatLng position) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}";
    try {
      final Uri uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> shareGoogleMapsLinkOnWhatsApp(double lat, double lon) async {
    // Koordinatları düzgün şekilde URL'ye yerleştiriyoruz
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent('$lat,$lon')}';

    // WhatsApp paylaşım URL'si
    final String whatsappUrl = 'https://api.whatsapp.com/send?text=$googleMapsUrl';

    try {
      final Uri uri = Uri.parse(whatsappUrl);
      // WhatsApp uygulamasının açılıp açılamadığını kontrol et
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print("WhatsApp'a yönlendirilemedi.");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }


  Future<void> updateAddress(AddressModel address) async{
    await db.updateAddress(address);
    notifyListeners();
  }

}
