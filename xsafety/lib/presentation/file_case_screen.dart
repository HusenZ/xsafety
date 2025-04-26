import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:xsafety/constants/police_station_c.dart';
import 'package:xsafety/controllers/file_case_controller.dart';



class FileCaseScreen extends StatefulWidget {
  const FileCaseScreen({super.key});

  @override
  State<FileCaseScreen> createState() => _FileCaseScreenState();
}

class _FileCaseScreenState extends State<FileCaseScreen> {
  final controller = Get.put(CaseFilingController());
  Map<String, String>? selectedStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title:  Text("File a Complaint", style: TextStyle(color: Colors.white,fontSize: 20.sp),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              child: Obx(() => TextField(
                    decoration: _inputDecoration("Case Title"),
                    onChanged: (val) => controller.title.value = val,
                    controller: TextEditingController(text: controller.title.value)
                      ..selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.title.value.length)),
                  )),
            ),
             SizedBox(height: 2.h),
            _buildCard(
              child: Obx(() => TextField(
                    maxLines: 5,
                    decoration: _inputDecoration("Case Description"),
                    onChanged: (val) => controller.description.value = val,
                    controller: TextEditingController(text: controller.description.value)
                      ..selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.description.value.length)),
                  )),
            ),
             SizedBox(height: 3.h),

            _buildCard(
  child: DropdownButtonHideUnderline(
    child: DropdownButton<Map<String, String>>(
      isExpanded: true,
      value: selectedStation,
      hint: const Text("Select Police Station"),
      items: belgaumPoliceStations.map((station) {
        return DropdownMenuItem<Map<String, String>>(
          value: station,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                station["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                station["location"]!,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              // Don't add Divider here!
            ],
          ),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          selectedStation = val;
          controller.policeStation.value = val?['name'] ?? '';
        });
      },
    ),
  ),
),


             SizedBox(height: 2.5.h),
            _submitButton(),

            if (selectedStation != null) ...[
               SizedBox(height: 3.h),
              _buildCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Selected Station Contact:",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                    ),
                     SizedBox(height: 1.5.h),
                    Text(
                      selectedStation!['contact']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                     SizedBox(height: 2.h),
                    _callButton(selectedStation!['contact']!)
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  /// Styled InputDecoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: InputBorder.none,
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );
  }

  /// Card Wrapper
  Widget _buildCard({required Widget child, EdgeInsets? padding}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: child,
      ),
    );
  }

  /// Submit Button
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => controller.fileCase(),
        icon: const Icon(Icons.file_present_rounded),
        label: const Text("Submit Case"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Call Button
  Widget _callButton(String number) {
    return InkWell(
      onTap: () => controller.launchCall(number),
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.teal],
          ),
        ),
        child: const Center(
          child: Text(
            "Call Now",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
