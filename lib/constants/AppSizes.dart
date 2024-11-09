import 'package:flutter/cupertino.dart';

class AppSizes {
  // Sabit Padding Değerleri
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double borderRadius = 12.0;

  // Ekran Boyutları
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive Yazı Boyutlandırma
  // yayın yazı boyutlarının dışında kullanmak istenildiği zaman bu metod çağrılır.
  static double responsiveFontSize(BuildContext context, double fontSize) {
    double scaleFactor = MediaQuery.of(context).size.width / 375; // Referans genişlik
    return fontSize * scaleFactor;
  }

  // Yaygın Yazı Boyutları
  static double getSmallFontSize(BuildContext context) => responsiveFontSize(context, 12);
  static double getNormalFontSize(BuildContext context) => responsiveFontSize(context, 14);
  static double getMediumFontSize(BuildContext context) => responsiveFontSize(context, 16);
  static double getLargeFontSize(BuildContext context) => responsiveFontSize(context, 20);
  static double getExtraLargeFontSize(BuildContext context) => responsiveFontSize(context, 24);
}
