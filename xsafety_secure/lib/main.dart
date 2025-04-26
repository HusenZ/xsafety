import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xsafety_secure/contorllers/auth_controller.dart';
import 'package:xsafety_secure/core/app.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(AuthController());
  runApp( MyApp());
}
