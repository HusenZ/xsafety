import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:xsafety/controllers/gardian_controller.dart';
import '../controllers/user_profile_controller.dart';

class UserProfileScreen extends StatefulWidget {

  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}
class _UserProfileScreenState extends State<UserProfileScreen> {
  final controller = Get.put(UserProfileController());
  final guardianController = Get.put(GuardianController());
  final isEditing = false.obs;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(body: Center(child: Text("User not logged in")));
    }

    controller.loadUser(uid);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text("User Profile", style: TextStyle(color: Colors.red,fontSize: 20.sp),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Obx(() => TextButton(
                onPressed: () => isEditing.value = !isEditing.value,
                child: Text(
                  isEditing.value ? "Cancel" : "Edit",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
      body: Obx(() {
        final user = controller.userModel.value;
        final editing = isEditing.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              profileField("Name", user.name, editable: editing, onChanged: (val) => controller.setField("name", val)),
              profileField("Age", user.age, editable: editing, onChanged: (val) => controller.setField("age", val)),
              profileField("Address", user.address, editable: editing, onChanged: (val) => controller.setField("address", val)),
              profileField("Phone", user.phone, editable: editing, onChanged: (val) => controller.setField("phone", val)),
              profileField("Email", user.email, editable: false),
              profileField("Blood Group", user.bloodGroup, editable: false),
              profileField("Emergency Name", user.emergencyName, editable: editing, onChanged: (val) => controller.setField("emergencyName", val)),
              profileField("Emergency Phone", user.emergencyPhone, editable: editing, onChanged: (val) => controller.setField("emergencyPhone", val)),

              SizedBox(height: 24),
              Text("Guardian Details", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),

              Obx(() {
                if (!guardianController.isGuardianAdded.value) {
                  return OutlinedButton.icon(
                    icon: Icon(Icons.person_add_alt, color: Colors.white,),
                    label: Text("Add Guardian", style: TextStyle(color: Colors.white,),),
                  
                    onPressed: showGuardianFormOverlay,
                  );
                }

                return Card(
                  margin: EdgeInsets.only(top: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Name: ${guardianController.guardianName.value}"),
                    subtitle: Text("Phone: ${guardianController.guardianPhone.value}"),
                  ),
                );
              }),

              if (editing)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text("Save Changes"),
                    onPressed: controller.updateUserDetails,
                  ),
                )
            ],
          ),
        );
      }),
    );
  }

  void showGuardianFormOverlay() {
    guardianController.clearForm();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Add Guardian Details", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 2.h),

              Obx(() => TextField(
                    controller: guardianController.nameController,
                    decoration: InputDecoration(
                      labelText: "Guardian Name",
                      errorText: guardianController.nameError.value,
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  )),
              SizedBox(height: 16),

              Obx(() => TextField(
                    controller: guardianController.phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Guardian Phone",
                      errorText: guardianController.phoneError.value,
                      border: OutlineInputBorder(),
                    ),
                  )),
              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: guardianController.validateAndSave,
                icon: Icon(Icons.check_circle),
                label: Text("Save Guardian"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget profileField(
    String label,
    String value, {
    bool editable = true,
    Function(String)? onChanged,
  }) {
    if (editable && onChanged != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(label),
        subtitle: Text(value),
        leading: Icon(Icons.info_outline),
      ),
    );
  }
}
