import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../constants/AppStrings.dart';
import '../constants/CustomSnackBar.dart';
import '../services/LocationService.dart';
import '../view_model/MapPageViewModel.dart';
import '../widgets/CustomAppBarWidget.dart';

final viewModel = ChangeNotifierProvider((ref) => MapPageViewModel());

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  Position? positioned;
  TextEditingController? addressName = TextEditingController();
  TextEditingController? search = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    positioned = await LocationService().determinePosition(context);
    if (positioned != null) {
      // Kullanıcı konumu alındıysa, marker ekle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(viewModel).addMarkers(ref.read(viewModel).createMarker(positioned!.latitude, positioned!.longitude));
      });
    } else {
      print("Konum alınamadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModel);
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: AppStrings.appName,
        isBack: true,
        onPressed: () => Navigator.pushReplacementNamed(context, "/home_page"),
      ),
      body: _buildBody(watch),
    );
  }

  Widget _buildBody(MapPageViewModel watch) {
    if (positioned == null) {
      return const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(AppStrings.get_location_info),
          const SizedBox(height: 7,),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.green),
          )
        ],
      ));
    }
    return FlutterMap(
      options: watch.mapOptions(
        positioned!.latitude,
        positioned!.longitude,
            (position) => _showAddressInfoBottomSheet(position),
      ),
      children: [
        watch.layers(),
        MarkerLayer(markers: watch.getMarkers),
      ],
    );
  }

  // Adres bilgilerini gösteren BottomSheet
  void _showAddressInfoBottomSheet(LatLng position) async {
    var address = await ref.read(viewModel).findLocationInfoWithLatAndLon(position.latitude, position.longitude);
    if (address != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,  // Alt sheet'i daha esnek yapar
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,  // Genişliği ekranın tamamına yay
            padding: const EdgeInsets.all(16.0),  // İçeriği biraz daha rahat görmek için padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(AppStrings.address_info, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 10),
                TextField(
                  controller: addressName,
                  decoration: const InputDecoration(
                    hintText: AppStrings.address_name,
                  ),
                ),
                const SizedBox(height: 10),
                Text('${AppStrings.neighbourhood} ${address.subLocality ?? AppStrings.unknow}'),
                Text('${AppStrings.province} ${address.administrativeArea ?? AppStrings.unknow}'),
                Text('${AppStrings.district} ${address.locality ?? AppStrings.unknow}'),
                Text('${AppStrings.county} ${address.country ?? AppStrings.unknow}'),
                Text('${AppStrings.subThoroughfare} ${address.subThoroughfare ?? AppStrings.unknow}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if(addressName!.text.isNotEmpty){
                      address.addressName = addressName!.text;
                      await ref.read(viewModel).db.newAddress(address);  // Adresi veritabanına kaydet
                      CustomSnackBar.show(context, AppStrings.saved_address);
                    }else{
                      CustomSnackBar.show(context, AppStrings.enter_addres_name);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.save),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
