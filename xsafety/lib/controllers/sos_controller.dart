import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SosController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> triggerSOS(String userId) async {
    try {
      // Step 1: Check and request location permission
      bool hasPermission = await _handleLocationPermission();
      if (!hasPermission) return;

      // Step 2: Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Step 3: Prepare SOS data
      final sosData = {
        'userId': userId,
        'status':'active',
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Step 4: Save to Firestore (e.g., under /sos_requests/{userId})
      await _firestore.collection('sos_requests').doc(userId).set(sosData);

      Get.snackbar("SOS Sent", "Location shared successfully 🚨");
    } catch (e) {
      print("SOS Error: $e");
      Get.snackbar("Error", "Could not send SOS");
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Disabled", "Please enable GPS to use SOS.");
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location permission is needed.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Denied", "Open app settings to grant permission.");
      return false;
    }

    return true;
  }
}
