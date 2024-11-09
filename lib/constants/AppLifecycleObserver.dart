import 'package:flutter/material.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final Function onAppBackground;
  final Function onAppForeground;
  final Function? onAppInactive;
  final Function? onAppDetached;

  AppLifecycleObserver({
    required this.onAppBackground,
    required this.onAppForeground,
    this.onAppInactive,
    this.onAppDetached,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      // Uygulama geçici olarak etkileşimsiz olduğunda
        if (onAppInactive != null) {
          onAppInactive!();
        }
        break;
      case AppLifecycleState.paused:
      // Uygulama arka planda olduğunda
        onAppBackground();
        break;
      case AppLifecycleState.resumed:
      // Uygulama tekrar ön plana geldiğinde
        onAppForeground();
        break;
      case AppLifecycleState.detached:
      // Uygulama kaynaklardan ayrılmak üzere olduğunda
        if (onAppDetached != null) {
          onAppDetached!();
        }
        break;

      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }
}
