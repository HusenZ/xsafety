import 'package:admin_final/models/rescuer_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerGroupsController extends GetxController {
  RxList<RescuerGroup> rescuerGroups = <RescuerGroup>[].obs;

  @override
  void onInit() {
    fetchRescuerGroups();
    super.onInit();
  }

  void fetchRescuerGroups() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rescueteams')
          .get();

      rescuerGroups.value = snapshot.docs.map((doc) {
        return RescuerGroup.fromDoc(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

Future<void> updateGroupStatus(String docId, String newStatus) async {
  try {
    await FirebaseFirestore.instance
        .collection('rescueteams') // ← Make sure collection name is correct
        .doc(docId)
        .update({'status': newStatus});

    fetchRescuerGroups(); // Refresh list

    Get.snackbar(
      "Success",
      "Group has been ${newStatus == 'approved' ? 'approved' : 'rejected'} successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  } catch (e) {
    print('Error updating status: $e');

    Get.snackbar(
      "Error",
      "Failed to update status. Please try again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }
}

}
