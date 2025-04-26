import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class UserProfileController extends GetxController {
  var userModel = UserModel(
    uid: '',
    name: '',
    age: '',
    address: '',
    phone: '',
    email: '',
    bloodGroup: '',
    emergencyName: '',
    emergencyPhone: '',
  ).obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  void loadUser(String uid) async {
    try {
      isLoading.value = true;
      var doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists && doc.data() != null) {
        userModel.value = UserModel.fromMap(doc.data()!);
      } else {
        Get.snackbar("Error", "User data not found");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateUserDetails() async {
    try {
      isLoading.value = true;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      if (userModel.value.uid.isEmpty) {
        throw "User ID is missing.";
      }

      await _firestore
          .collection("users")
          .doc(uid)
          .update(userModel.value.toMap());

      Get.snackbar("Success", "User details updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update user details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void setField(String key, String value) {
    userModel.update((val) {
      if (val == null) return;
      switch (key) {
        case 'name':
          val.name = value;
          break;
        case 'age':
          val.age = value;
          break;
        case 'address':
          val.address = value;
          break;
        case 'phone':
          val.phone = value;
          break;
        case 'emergencyName':
          val.emergencyName = value;
          break;
        case 'emergencyPhone':
          val.emergencyPhone = value;
          break;
      }
    });
  }
}
