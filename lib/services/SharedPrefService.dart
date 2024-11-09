import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/AppStrings.dart';
import '../constants/CustomSnackBar.dart';


class SharedPrefService{

  //Veri kaydet
  static Future<void> save(BuildContext context, String name, List<String> data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(name, data);
    CustomSnackBar.show(context, AppStrings.save);
  }

  //Kayıtlı veriyi oku
  static Future<List<String>?> read(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? colors = await sharedPreferences.getStringList(name);
    return colors;
  }

}