import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/AppStrings.dart';
import '../constants/CustomSnackBar.dart';

class LocationService {

  Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cihazda konum servislerinin aktif olup olmadığı kontrol edilir.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum servisleri kapalı ise kullanıcıyı bilgilendir
      CustomSnackBar.show(context, AppStrings.locatipn_service_disabled);
    }

    // Uygulamanın konum bilgisine erişim izni olup olmadığı kontrol edilir.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Kullanıcı izni reddetti, tekrar izin isteniyor
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Kullanıcı izni tekrar reddederse, ona uygun bir mesaj gösterilebilir.
        CustomSnackBar.show(context, AppStrings.locatipn_permission_denied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Eğer kullanıcı konum iznini kalıcı olarak reddetmişse, kullanıcıyı ayarlara yönlendir
      CustomSnackBar.show(context, AppStrings.locatipn_permission_deniedForever);

      // Ayarlara yönlendirme yapalım
      await openAppSettings();
    }

    // Eğer her şey yolundaysa (konum servisleri açık ve izinler verilmişse)
    try {
      //kullanıcın konumunu al
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      CustomSnackBar.show(context, AppStrings.error + e.toString());
      return Future.error('Konum alınırken bir hata oluştu.');
    }

  }


  // Uygulama ayarları sayfasını açmak için method
  Future<void> openAppSettings() async {
    try {
      final Uri uri = Uri.parse('app-settings:');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
      }
    } catch (e) {
      print("Ayarlara yönlendirme hatası: $e");
    }
  }

}
