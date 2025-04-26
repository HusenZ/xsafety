import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:xsafety/core/app_theme.dart';
import 'package:xsafety/presentation/emergency_type_screen.dart';
import 'package:xsafety/presentation/file_case_screen.dart';
import 'package:xsafety/presentation/home_screen.dart';
import 'package:xsafety/presentation/login_screen.dart';
import 'package:xsafety/presentation/register_screen.dart';
import 'package:xsafety/presentation/splash_screen.dart';
import 'package:xsafety/presentation/user_profile_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static MyApp instance = const MyApp._internal();

  @override
  State<MyApp> createState() => _MyAppState();

  factory MyApp() => instance;
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, 
        statusBarBrightness:
            Brightness.light, 
      ),
    );

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const SplashScreen()),
            GetPage(name: '/login', page: () => const LoginScreen()),
            GetPage(name: '/register', page: () => const RegisterScreen()),
            GetPage(name: '/home', page: () => const HomeScreen()),
            GetPage(name: '/emergency-Type', page: () => const EmergencyTypeScreen(),),
            GetPage(name: '/myprofile', page: () =>  UserProfileScreen(),),
            GetPage(name: '/fielcase', page: () => FileCaseScreen(),)
          ],
          theme: appTheme,
        );
      },
    );
  }
}
