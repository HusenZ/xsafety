import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuardianController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final nameError = RxnString();
  final phoneError = RxnString();

  final isGuardianAdded = false.obs;
  final guardianName = "".obs;
  final guardianPhone = "".obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  void validateAndSave() async {
    nameError.value = null;
    phoneError.value = null;

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) {
      nameError.value = "Name is required";
    }

    if (phone.isEmpty || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      phoneError.value = "Enter a valid 10-digit phone number";
    }

    if (nameError.value == null && phoneError.value == null) {
      try {
        if (uid == null) throw "User not logged in";

        await _firestore.collection('users').doc(uid).update({
          'guardian': {
            'name': name,
            'phone': phone,
          }
        });

        guardianName.value = name;
        guardianPhone.value = phone;
        isGuardianAdded.value = true;
        Get.back(); // Close the overlay
        Get.snackbar("Success", "Guardian details saved successfully");
      } catch (e) {
        Get.snackbar("Error", "Failed to save guardian details: $e");
      }
    }
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    nameError.value = null;
    phoneError.value = null;
  }

  void loadGuardianDetails(Map<String, dynamic>? data) {
    if (data == null || data['guardian'] == null) return;

    final guardian = data['guardian'];
    guardianName.value = guardian['name'] ?? '';
    guardianPhone.value = guardian['phone'] ?? '';
    isGuardianAdded.value = true;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
