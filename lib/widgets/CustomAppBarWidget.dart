import 'package:flutter/material.dart';
import '../constants/AppSizes.dart';
import '../constants/AppStrings.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color? background;
  final bool isBack;
  final bool actions;
  final VoidCallback? onPressed;

  CustomAppBarWidget({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.background,
    this.isBack = false,
    this.actions = false,
    this.onPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Tema bilgilerini alıyoruz
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: background,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppSizes.paddingLarge,
        ),
      ),
      centerTitle: centerTitle,
      leading: isBack
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? Colors.white : Colors.black, // Tema rengine göre ayar
        ),
        onPressed: onPressed,
      )
          : null,
      actions: actions
          ? [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: isDarkMode ? Colors.white : Colors.black, // Tema rengine göre ayar
          ),
          onSelected: (String result) {
            switch (result) {
              case "location":
                Navigator.pushReplacementNamed(context, "/map_page");
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'location',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, color: Colors.green),
                  SizedBox(width: 5),
                  Text(AppStrings.map),
                ],
              ),
            ),
          ],
        ),
      ]
          : null,
    );
  }
}
