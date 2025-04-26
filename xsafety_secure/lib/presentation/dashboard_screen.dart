import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

class RescuerDashboard extends StatelessWidget {
  const RescuerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(
          'Rescuer Dashboard',
          style: TextStyle(color: const Color.fromARGB(255, 18, 7, 7)),
        ),
        backgroundColor: const Color.fromARGB(217, 242, 171, 171),
      ),
      drawerScrimColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade900, Colors.red.shade700],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'John Rescuer',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Region: Downtown',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Assigned Region'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: const AlertDashboardContent(),
    );
  }
}

class AlertDashboardContent extends StatelessWidget {
  const AlertDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Current Alert Section
        _buildCurrentAlert(),
        const SizedBox(height: 24),

        // History Section Title
        Row(
          children: [
            const Icon(Icons.history, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Alert History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Alert History List
        _buildAlertHistory(),
      ],
    );
  }

 Widget _buildCurrentAlert() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('sos_requests')
        .where('status', isEqualTo: 'active')       
        .limit(1)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade900,
          ),
          child: const Center(
            child: Text(
              'No active alerts at the moment.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }

      final alert = snapshot.data!.docs.first;
      final data = alert.data() as Map<String, dynamic>;

      final double latitude = data['latitude'];
      final double longitude = data['longitude'];
      final String userId = data['userId'];

      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>?;

          final String userName = userData?['name'] ?? 'Unknown';
          final String phone = userData?['phone'] ?? 'N/A';
          final String emergencyContact = userData?['emergencyPhone'] ?? 'N/A';

          return FutureBuilder<String>(
            future: getPlaceName(latitude, longitude),
            builder: (context, placeSnapshot) {
              final String locationName = placeSnapshot.data ?? 'Unknown location';

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Card(
                  color: Colors.red.shade900.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.warning, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'ACTIVE SOS ALERT',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildInfoRow(icon:  Icons.access_time,label:  timeAgoFromTimestamp(data['timestamp'])),
                        _buildInfoRow(icon: Icons.person, label:  'Name: $userName'),
                        _buildInfoRow(icon: Icons.phone, label: 'Phone: $phone'),
                        _buildInfoRow(icon: Icons.contact_emergency,label:  'Emergency Contact: $emergencyContact'),
                        _buildInfoRow(icon: Icons.location_on,label:  locationName),

                        const SizedBox(height: 16),

                        // Map Preview
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=600x300&markers=color:red%7C$latitude,$longitude&key=YOUR_GOOGLE_MAPS_API_KEY',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Text('Map preview failed')),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.navigation),
                                label: const Text('Navigate'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () {
                                  final googleMapsUrl =
                                      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
                                  launchUrl(Uri.parse(googleMapsUrl));
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Respond'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.all(16),
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('sos_requests')
                                      .doc(alert.id)
                                      .update({'status': 'responded'});
                                },
                              ),
                            ),
                          ],
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
    },
  );
}


  Widget _buildAlertHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('sos_requests')
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            'No alert history.',
            style: TextStyle(color: Colors.white),
          );
        }

        final alerts = snapshot.data!.docs;

        return Column(
          children:
              alerts.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildHistoryCard(data);
              }).toList(),
        );
      },
    );
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  String timeAgoFromTimestamp(Timestamp timestamp) {
  final now = DateTime.now();
  final date = timestamp.toDate();
  final diff = now.difference(date);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';
  return '${diff.inDays} days ago';
}


 Widget _buildHistoryCard(Map<String, dynamic> data) {
  final timestamp = data['timestamp'];
  final latitude = data['latitude']?.toString() ?? 'N/A';
  final longitude = data['longitude']?.toString() ?? 'N/A';
  final userId = data['userId'] ?? 'Unknown';
  final status = data['status'] ?? 'Unknown';

  return Card(
    color: Colors.grey.shade900,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.access_time,
            label: timestamp != null
                ? timeAgoFromTimestamp(timestamp)
                : 'No timestamp',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.person,
            label: 'User ID: $userId',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.my_location,
            label: 'Lat: $latitude, Lng: $longitude',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.flag,
            label: 'Status: $status',
          ),
        ],
      ),
    ),
  );
}

Widget _buildInfoRow({required IconData icon, required String label}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: Colors.white70, size: 20),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}





Future<String> getPlaceName(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return "${place.street}, ${place.locality}, ${place.administrativeArea}";
    }
  } catch (e) {
    print('Error in geocoding: $e');
  }
  return 'Unknown location';
}
}