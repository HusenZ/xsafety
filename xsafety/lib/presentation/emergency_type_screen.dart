import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xsafety/presentation/emergency_chat_screen.dart';

class EmergencyTypeScreen extends StatelessWidget {
  const EmergencyTypeScreen({super.key});

  void _selectEmergency(BuildContext context, String type) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('$type Emergency'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose an option below for "$type".'),
                 SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Get.to(() => EmergencyChatScreen(emergencyType: type));
                      },
                      child: const Text('Learn'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSOSDialog(context, type);
                      },

                      label: const Text('SOS Help'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void _showLearnDialog(BuildContext context, String type) {
    String info = '';
    switch (type) {
      case 'Medical':
        info =
            'Medical emergencies include heart attacks, injuries, or unconsciousness. Call 108 or provide first aid.';
        break;
      case 'Fire':
        info =
            'In case of fire, evacuate immediately and call 101. Avoid elevators and use stairs.';
        break;
      case 'Crime':
        info =
            'Crimes such as theft or harassment must be reported to 100. Ensure your safety before intervening.';
        break;
      case 'Accident':
        info =
            'Accidents need immediate care. Call 102 or 103 for medical and traffic support.';
        break;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('About $type Emergency'),
            content: Text(info),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSOSDialog(BuildContext context, String type) {
    final emergencyNumbers = {
      'Medical': {'🩺 Hospital': '108', '🚑 Ambulance': '102'},
      'Fire': {'🔥 Fire Station': '101'},
      'Crime': {'🚓 Police': '100', '👩‍⚖️ Women Helpline': '1091'},
      'Accident': {'🚑 Ambulance': '102', '🚔 Traffic Helpline': '103'},
    };

    final numbers = emergencyNumbers[type]!;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('$type Emergency Contacts'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  numbers.entries.map((entry) {
                    return ListTile(
                      leading: Text(entry.key),
                      title: Text('Call ${entry.value}'),
                      trailing: Icon(Icons.call, color: Colors.green),
                      onTap: () => _makePhoneCall(entry.value),
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Future<void> _makePhoneCall(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        "Error",
        "Could not dial $number",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title:  Text("Select Emergency Type", style: TextStyle(color: Colors.white, fontSize: 17.sp) ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EmergencyCard(
                icon: Icons.health_and_safety,
                label: "Medical Emergency",
                color: Colors.tealAccent,
                onTap: () => _selectEmergency(context, "Medical"),
              ),
              EmergencyCard(
                icon: Icons.local_fire_department,
                label: "Fire Emergency",
                color: Colors.orangeAccent,
                onTap: () => _selectEmergency(context, "Fire"),
              ),
              EmergencyCard(
                icon: Icons.security,
                label: "Crime / Safety",
                color: Colors.redAccent,
                onTap: () => _selectEmergency(context, "Crime"),
              ),
              EmergencyCard(
                icon: Icons.directions_car,
                label: "Accident / Road Mishap",
                color: Colors.yellowAccent,
                onTap: () => _selectEmergency(context, "Accident"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const EmergencyCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28.sp, color: color),
            SizedBox(width: 5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
