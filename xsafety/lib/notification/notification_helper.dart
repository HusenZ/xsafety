// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NotificationHelper {
//   static Future<void> setupFCM() async {
//     final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//     // Request permission for iOS
//     await _fcm.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Get the token
//     final token = await _fcm.getToken();
//     print('FCM Token: $token');

//     // Save it to Firestore (assuming user is logged in)
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null && token != null) {
//       await FirebaseFirestore.instance.collection('users').doc(uid).update({
//         'fcmToken': token,
//       });
//     }
//   }
// }
