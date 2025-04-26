import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class WaitingApprovalScreen extends StatelessWidget {
  final String message;
  const WaitingApprovalScreen({
    super.key,
    this.message = 'Your team registration is under review. Please wait for approval.',
  });

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>? _getRescuerDocStream(String uid) {
    return FirebaseFirestore.instance
        .collection('rescueteams').doc(FirebaseAuth.instance.currentUser!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserId(),
      builder: (context, snapshot) {
        final uid = snapshot.data;
        if (!snapshot.hasData || uid == null) {
          return  Scaffold(
              backgroundColor:  Color.fromARGB(255, 12, 5, 65),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Lottie.asset('assets/lotties/waiting.json'),
                Padding(
                  padding:  EdgeInsets.all(9.sp),
                  child: Container(
                    padding:  EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.sp),
                      color: Colors.white
                    ),
                  
                    child: Text('Your team registration is under review. Please wait for approval.', style: TextStyle(color: Colors.black, fontSize: 18.sp),),
                  ),
                ),
              ],
            ),
          );
        }

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
          future: _getRescuerDocStream(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
              backgroundColor:  Color.fromARGB(255, 11, 11, 11),
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final doc = snapshot.data;
            final data = doc?.data();
            final status = data?['status'];

            if (status == 'approved') {
              // Wait a tiny bit before navigating to prevent build errors
              Future.delayed(Duration.zero, () {
                Get.offAllNamed('/home');
              });
            }

            return Scaffold(
              appBar: AppBar(title: const Text('Waiting for Approval')),
              backgroundColor: const Color.fromARGB(255, 11, 11, 11),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style:  TextStyle(fontSize: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
