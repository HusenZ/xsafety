import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

    Future<void> navigateUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (!isLoggedIn) {
    Get.offAllNamed('/login');
    return;
  }
  final uid = FirebaseAuth.instance.currentUser!.uid;
  print('-------------------->$uid');
  
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('rescueteams')
        .doc(uid)
        .get();

    final status = snapshot['status'] ?? 'pending';

    if (status.toLowerCase() == 'approved') {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/waitingApproval');
    }
  } catch (e) {
    print("Error fetching approval status: $e");
    Get.snackbar('Error', 'Failed to fetch approval status');
    Get.offAllNamed('/waitingApproval');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21), // Dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace with your logo
            // Image.asset(
            //   'assets/logo.png',
            //   height: 120,
            // ),
            const SizedBox(height: 20),
            const Text(
              'X-SAFETY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'One Tap. Instant Help.\nEven Without Internet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
