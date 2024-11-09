import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../constants/CustomSnackBar.dart';
import '../model/AddressModel.dart';
import '../services/AddressDatabase.dart';

class MapPageViewModel extends ChangeNotifier {
  AddressDatabase db = AddressDatabase.instance;
  List<Marker> _markers = [];

  get getMarkers => _markers;

  // Harita ayarları
  MapOptions mapOptions(double lat, double lon, Function(LatLng) onLongPress) {
    return MapOptions(
      initialCenter: LatLng(lat, lon),
      initialZoom: 15,
      onLongPress: (tapPosition, position) {
        addMarkers(createMarker(position.latitude, position.longitude));
        onLongPress(position);
      },
    );
  }

  // Harita türü
  TileLayer layers() {
    return TileLayer(
      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
      subdomains: const ['a', 'b', 'c'],
    );
  }

  // Marker oluşturma fonksiyonu
  Marker createMarker(double lat, double lon) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(lat, lon),
      child: const Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40.0,
      ),
    );
  }

  // Haritaya marker ekle
  void addMarkers(Marker marker) {
    _markers.clear();
    _markers.add(marker);
    notifyListeners();
  }

  // Adres bilgilerini konuma göre al
  Future<AddressModel?> findLocationInfoWithLatAndLon(
      double lat, double lon) async {
    AddressModel? newAddress;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        newAddress = AddressModel(
          addressName: "",
          street: place.street!,
          subLocality: place.subLocality!,
          locality: place.locality!,
          administrativeArea: place.administrativeArea!,
          country: place.country!,
          subThoroughfare: place.subThoroughfare!,
          lat: lat,
          lon: lon
        );
      }
    } catch (e) {
      print('Adres bilgisi alınamadı: $e');
      newAddress = null;
    }
    return newAddress;
  }


  // Adres arama fonksiyonu
  Future<void> searchAddress(BuildContext context, String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        createMarker(location.latitude, location.longitude);
      }
    } catch (e) {
      CustomSnackBar.show(context, "Adres bulunamadı");
    }
  }
}
