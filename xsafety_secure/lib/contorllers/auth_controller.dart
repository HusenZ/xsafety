import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show Colors, FormState, GlobalKey;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  
  // Login User
  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('rescueteams')
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



class TeamMember {
  final String name;
  final String phone;

  TeamMember({required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class RegistrationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  var groupName = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var contactNumber = ''.obs;
  var groupLeaderName = ''.obs;
  var description = ''.obs;

  var teamMembers = <TeamMember>[].obs;

  // Validators
  String? validateGroupName(String? value) {
    if (value == null || value.isEmpty) return 'Group Name is required';
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || !GetUtils.isEmail(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Include uppercase, lowercase & number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != password.value) return 'Passwords do not match';
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || !RegExp(r'^\d{10}$').hasMatch(value)) return 'Enter valid 10-digit phone number';
    return null;
  }

  // Team Members
  void addTeamMember(String name, String phone) {
    teamMembers.add(TeamMember(name: name, phone: phone));
  }

  void removeTeamMember(int index) {
    teamMembers.removeAt(index);
  }

  // Registration + Firestore Save
  Future<void> registerAndSubmit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    isLoading.value = true;

    try {
      // 1. Create user
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      final uid = userCred.user!.uid;

      // 2. Store rescue team data
      final rescueData = {
        'uid': uid,
        'groupName': groupName.value,
        'city': city.value,
        'state': state.value,
        'status':'pending',
        'email': email.value,
        'contactNumber': contactNumber.value,
        'groupLeaderName': groupLeaderName.value,
        'description': description.value,
        'teamMembers': teamMembers.map((member) => member.toMap()).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('rescueteams').doc(uid).set(rescueData);

      // 3. Save login state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // 4. Navigate
      Get.offAllNamed('/waitingApproval');

      // 5. Optional: success toast
      Get.snackbar(
        'Success',
        'Rescue Team Registered Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      resetForm();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    formKey.currentState?.reset();
    groupName.value = '';
    city.value = '';
    state.value = '';
    email.value = '';
    password.value = '';
    confirmPassword.value = '';
    contactNumber.value = '';
    groupLeaderName.value = '';
    description.value = '';
    teamMembers.clear();
  }
}
