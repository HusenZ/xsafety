import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  // Register User
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String emergencyName,
    required String emergencyPhone,
    required String bloodGroup,
    required String age,
    required String address,
  }) async {
    try {
      isLoading.value = true;

      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCred.user!.uid).set({
        'uid': userCred.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'emergencyName': emergencyName,
        'emergencyPhone': emergencyPhone,
        'bloodGroup': bloodGroup,
        'age': age,
        'address': address,
        'createdAt': Timestamp.now(),
      });

      // Save login state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true).then((value) {
        if (value) {
          Get.offAllNamed('/home');
        }
      });

      //Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Login User
  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (query.docs.isEmpty) {
        Get.snackbar(
          'User Not Found',
          'No account registered with this email.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true).then((value) {
        if (value) {
          Get.offAllNamed('/home');
        }
      });
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'wrong-password')
        message = 'Incorrect password';
      else if (e.code == 'user-disabled')
        message = 'Account is disabled';
      else if (e.code == 'invalid-email')
        message = 'Invalid email address';

      Get.snackbar(
        'Authentication Error',
        message,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Get.offAllNamed('/login');
  }

  // Get current user UID
  String? get uid => _auth.currentUser?.uid;
}
