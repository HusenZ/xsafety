import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:xsafety_secure/contorllers/auth_controller.dart';

class RegistrationScreen extends StatelessWidget {
  final controller = Get.put(RegistrationController());
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  RegistrationScreen({super.key});

  void _showAddTeamMemberDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text(
          'Add Team Member',
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                labelText: 'Name *',
                controller: nameController,
                validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                labelText: 'Phone *',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: controller.validateContactNumber,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                controller.addTeamMember(
                  nameController.text,
                  phoneController.text,
                );
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DE9B6),
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: Color(0xFF0A0E21)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: FadeIn(
          duration: const Duration(milliseconds: 800),
          child: const Text(
            'Rescuer Group Registration',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF1D1E33),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: _buildTextField(
                    labelText: 'Group Name *',
                    validator: controller.validateGroupName,
                    onSaved: (value) => controller.groupName.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: _buildTextField(
                    labelText: 'City *',
                    validator: (value) => controller.validateRequired(value, 'City'),
                    onSaved: (value) => controller.city.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: _buildTextField(
                    labelText: 'State *',
                    validator: (value) => controller.validateRequired(value, 'State'),
                    onSaved: (value) => controller.state.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  duration: const Duration(milliseconds: 900),
                  child: _buildTextField(
                    labelText: 'Email *',
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    onSaved: (value) => controller.email.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: _buildTextField(
                    labelText: 'Password *',
                    obscureText: true,
                    helperText: 'Min 8 chars, 1 uppercase, 1 lowercase, 1 number',
                    validator: controller.validatePassword,
                    onSaved: (value) => controller.password.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                
                FadeInDown(
                  duration: const Duration(milliseconds: 1200),
                  child: _buildTextField(
                    labelText: 'Contact Number *',
                    keyboardType: TextInputType.phone,
                    helperText: 'Enter 10-digit number',
                    validator: controller.validateContactNumber,
                    onSaved: (value) => controller.contactNumber.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  duration: const Duration(milliseconds: 1300),
                  child: _buildTextField(
                    labelText: 'Group Leader Name *',
                    validator: (value) => controller.validateRequired(value, 'Group Leader Name'),
                    onSaved: (value) => controller.groupLeaderName.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 16),
                FadeInDown(
                  duration: const Duration(milliseconds: 1400),
                  child: _buildTextField(
                    labelText: 'Description (Optional)',
                    helperText: 'Tell us about your group',
                    maxLines: 3,
                    onSaved: (value) => controller.description.value = value ?? '',
                  ),
                ),
                const SizedBox(height: 24),
                
                // Team Members Section
                FadeInDown(
                  duration: const Duration(milliseconds: 1500),
                  child: Card(
                    color: const Color(0xFF1D1E33),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Team Members',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Color(0xFF1DE9B6),
                                  size: 30,
                                ),
                                onPressed: _showAddTeamMemberDialog,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(() => Column(
                            children: [
                              for (int i = 0; i < controller.teamMembers.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Card(
                                    color: Colors.white.withOpacity(0.1),
                                    child: ListTile(
                                      title: Text(
                                        controller.teamMembers[i].name,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        controller.teamMembers[i].phone,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                                        onPressed: () => controller.removeTeamMember(i),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  child: ElevatedButton(
                    onPressed: controller.registerAndSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF1DE9B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A0E21),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    String? helperText,
    bool obscureText = false,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        helperStyle: const TextStyle(color: Colors.white70),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: const Color(0xFF1D1E33),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
    );
  }
}