import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController emergencyName = TextEditingController();
  final TextEditingController emergencyPhone = TextEditingController();
  final TextEditingController bloodGroup = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController address = TextEditingController();

  bool loading = false;

  void registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      UserCredential userCred = await auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await firestore.collection('users').doc(userCred.user!.uid).set({
        'name': name.text.trim(),
        'email': email.text.trim(),
        'phone': phone.text.trim(),
        'emergencyName': emergencyName.text.trim(),
        'emergencyPhone': emergencyPhone.text.trim(),
        'bloodGroup': bloodGroup.text.trim(),
        'age': age.text.trim(),
        'address': address.text.trim(),
        'uid': userCred.user!.uid,
        'createdAt': Timestamp.now(),
      });

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(name, "Full Name"),
              _field(email, "Email", inputType: TextInputType.emailAddress),
              _field(password, "Password", isPassword: true),
              _field(phone, "Phone Number"),
              _field(emergencyName, "Emergency Contact Name"),
              _field(emergencyPhone, "Emergency Contact Number"),
              _field(bloodGroup, "Blood Group"),
              _field(age, "Age"),
              _field(address, "Address"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 14,
                  ),
                ),
                child:
                    loading
                        ? const CircularProgressIndicator(
                          color: Color.fromARGB(255, 81, 119, 241),
                        )
                        : Text("Register", style: TextStyle(fontSize: 16.sp)),
              ),
              TextButton(
                onPressed: () => Get.offNamed('/login'),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,

        validator: (val) => val!.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          labelText: label,

          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
