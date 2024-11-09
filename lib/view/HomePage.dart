import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../constants/AppStrings.dart';
import '../constants/CustomSnackBar.dart';
import '../view_model/HomePageViewModel.dart';
import '../widgets/CustomAppBarWidget.dart';

final viewModelProvider = ChangeNotifierProvider((ref) => HomePageViewModel());

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Veriyi ilk açılışta çekiyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(viewModelProvider).getAllAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModelProvider);
    var read = ref.read(viewModelProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.delete,color: Colors.white,),
        onPressed: () async {
          await ref.read(viewModelProvider).deleteAllAddress();
          CustomSnackBar.show(context, AppStrings.deleted_all_address);
          },
      ),
      appBar: CustomAppBarWidget(
        title: AppStrings.appName,
        actions: true,
      ),
      body: RefreshIndicator(
        onRefresh:_refreshData,
        child: watch.allAddress.isEmpty
            ? const Center(child: Text(AppStrings.emty_address_list)) // Yükleniyor göstergesi
            : getAllAddress(watch,read),
      ),
    );
  }

  Widget getAllAddress(HomePageViewModel watch, HomePageViewModel read){
    return ListView.builder(
      itemCount: watch.allAddress.length,
      itemBuilder: (BuildContext context, int index) {
        var address = watch.allAddress[index];
        return Card(
          elevation: 10.0,
          shadowColor: Colors.green,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(address.addressName ?? AppStrings.unknow),
            leading: IconButton(
              onPressed: () async {
                // Adres silme işlemi
                await ref.read(viewModelProvider).deleteAddress(address.id!);
              },
              icon: const Icon(Icons.delete, color: Colors.green),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    // Adres ismini güncelle
                    await _updateAddressName(context,address);
                  },
                  icon: const Icon(Icons.settings, color: Colors.grey),
                ),
                IconButton(
                  onPressed: () async {
                    await read.shareGoogleMapsLinkOnWhatsApp(address.lat!,address.lon!);
                  },
                  icon: const Icon(Icons.share, color: Colors.pinkAccent),
                ),
              ],
            ),
            //Tıklanan sayfaya git
            onTap: (){
              LatLng goAddress = LatLng(address.lat!, address.lon!);
              read.launchMapsUrl(goAddress);
            },
          ),
        );
      },
    );
  }



  // Adres ismini güncelleme diyaloğunu açan fonksiyon
  Future<void> _updateAddressName(BuildContext context, var address) async {
    TextEditingController controller = TextEditingController(text: address.addressName);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppStrings.update_address),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: AppStrings.new_address),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                String newAddressName = controller.text.trim();
                if (newAddressName.isNotEmpty) {
                  // Yeni adresi güncelle
                  await ref.read(viewModelProvider).updateAddress(
                    address.copyWith(addressName: newAddressName),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshData() async {
    await ref.read(viewModelProvider).getAllAddress();
    CustomSnackBar.show(context, AppStrings.uptaded);
  }


}
