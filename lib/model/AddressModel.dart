class AddressModel {
  int? id;
  String? addressName;
  String? street;
  String? subLocality;
  String? locality;
  String? administrativeArea;
  String? country;
  String? subThoroughfare;
  double? lat;
  double? lon;

  AddressModel({
    this.id,
    this.addressName,
    this.street,
    this.subLocality,
    this.locality,
    this.administrativeArea,
    this.country,
    this.subThoroughfare,
    this.lat,
    this.lon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': addressName,
      'street': street,
      'subLocality': subLocality,
      'locality': locality,
      'administrativeArea': administrativeArea,
      'country': country,
      'subThoroughfare': subThoroughfare,
      'lat': lat,
      'lon': lon,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      addressName: map['name'],
      street: map['street'],
      subLocality: map['subLocality'],
      locality: map['locality'],
      administrativeArea: map['administrativeArea'],
      country: map['country'],
      subThoroughfare: map['subThoroughfare'],
      lat: map['lat'] != null ? map['lat'] as double : null,
      lon: map['lon'] != null ? map['lon'] as double : null,
    );
  }

  // copyWith fonksiyonu ekleyelim
  AddressModel copyWith({
    String? addressName,
    double? lat,
    double? lon,
    int? id,
  }) {
    return AddressModel(
      addressName: addressName ?? this.addressName,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return '$addressName, $street, $subLocality, $locality, $administrativeArea, $country, $subThoroughfare, $lat, $lon';
  }
}
