import 'package:bolgelerim_app/view/HomePage.dart';
import 'package:bolgelerim_app/view/MapPage.dart';
import 'package:bolgelerim_app/view/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/AppLifecycleObserver.dart';
import 'constants/AppThemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Splash Screen için kontrol
  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;
  if (isFirstRun) {
    prefs.setBool('isFirstRun', false);
  }

  //uygulamayı başlat
  runApp(
    ProviderScope(
      child: MyApp(isFirstRun: isFirstRun),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isFirstRun;
  const MyApp({Key? key, required this.isFirstRun}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppLifecycleObserver _appLifecycleObserver;

  @override
  void initState() {
    super.initState();

    // AppLifecycleObserver ile yaşam döngüsü dinlemesi
    _appLifecycleObserver = AppLifecycleObserver(
      onAppBackground: () {
        // Arka plana alındığında çalışacak işlemler
        debugPrint("Uygulama arka planda.");
      },
      onAppForeground: () {
        // Öne geldiğinde çalışacak işlemler
        debugPrint("Uygulama ön planda.");
      },
    );

    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: AppThemes.darkTheme,
      theme: AppThemes.lightTheme,
      home: widget.isFirstRun ? const SplashPage() : HomePage(),
      routes: {
        "/home_page": (context) => HomePage(),
        "/splash_page": (context) => const SplashPage(),
        "/map_page": (context) => const MapPage(),
      },
    );
  }
}
