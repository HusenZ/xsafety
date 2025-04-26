import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xsafety/controllers/auth_controller.dart';
import 'package:xsafety/controllers/sos_controller.dart';
import 'package:xsafety/core/app.dart';


// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Background message received: ${message.messageId}");
//   // Optionally show local notification here
// }
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await NotificationHelper.setupFCM();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(AuthController());
  Get.put(SosController());
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   print('💬 Foreground message received');
//   print('Title: ${message.notification?.title}');
//   print('Body: ${message.notification?.body}');
// });
  runApp( MyApp());
}
