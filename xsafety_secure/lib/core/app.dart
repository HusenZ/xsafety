import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:xsafety_secure/core/app_theme.dart';
import 'package:xsafety_secure/presentation/dashboard_screen.dart';
import 'package:xsafety_secure/presentation/login_screen.dart';
import 'package:xsafety_secure/presentation/register_screen.dart';
import 'package:xsafety_secure/presentation/splash_screen.dart';
import 'package:xsafety_secure/presentation/waiting_approval.dart';

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
            GetPage(name: '/register', page: () =>  RegistrationScreen()),
            GetPage(name: '/home', page: () => const RescuerDashboard()),
            GetPage(name: '/waitingApproval', page: () => const WaitingApprovalScreen(),)
            /*GetPage(name: '/emergency-Type', page: () => const EmergencyTypeScreen(),),
            GetPage(name: '/myprofile', page: () =>  UserProfileScreen(),),
            GetPage(name: '/fielcase', page: () => FileCaseScreen(),)*/
          ],
          theme: appTheme,
        );
      },
    );
  }
}
