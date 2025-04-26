import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CaseFilingController extends GetxController {
  final title = ''.obs;
  final description = ''.obs;
  final policeStation = ''.obs;

  Future<void> fileCase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final caseData = {
        'title': title.value,
        'description': description.value,
        'policeStation': policeStation.value,
        'status': 'pending',
        'dateFiled': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cases')
          .add(caseData);

      Get.snackbar("Success", "Case filed successfully ✅");
      clearFields();
    } catch (e) {
      Get.snackbar("Error", "Failed to file case: $e");
    }
  }

  void launchCall(String phoneNumber) async {
  final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
  } else {
    Get.snackbar("Error", "Cannot launch dialer");
  }
}


  void clearFields() {
    title.value = '';
    description.value = '';
    policeStation.value = '';
  }
}
