import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:xsafety/controllers/sos_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'X-SAFETY',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello, Warrior!',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 2.h),

            // 🔴 SOS BUTTON
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    // Trigger emergency
                    final controller = Get.find<SosController>();
                    await controller.triggerSOS(
                      FirebaseAuth.instance.currentUser!.uid,
                    );
                    Get.snackbar(
                      "SOS Triggered",
                      "Your emergency alert has been sent!",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  },
                  child: Container(
                    height: size.width * 0.6,
                    width: size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // 🔗 Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickTile(
                  icon: Icons.health_and_safety,
                  label: "Emergency Type",
                  onTap: () => Get.toNamed('/emergency-Type'),
                ),
                _quickTile(
                  icon: Icons.cases,
                  label: "File Complaint",
                  onTap: () => Get.toNamed('/fielcase'),
                ),
                _quickTile(
                  icon: Icons.person,
                  label: "My profile",
                  onTap: () => Get.toNamed('/myprofile'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _quickTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white10,
            radius: 28,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
