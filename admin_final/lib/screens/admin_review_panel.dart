import 'package:admin_final/controller/rescure_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminReviewPanel extends StatelessWidget {
  const AdminReviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RescuerGroupsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel – Rescuer Teams',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Obx(() {
        final groups = controller.rescuerGroups;

        if (controller.rescuerGroups.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: controller.rescuerGroups.length,
            itemBuilder: (context, index) {
              final group = controller.rescuerGroups[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                elevation: 2,
                child: ExpansionTile(
                  backgroundColor: _getStatusColor(group.status, context),
                  title: Text(
                    group.groupName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    ' ${group.state}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection('Contact Information', [
                            _buildInfoRow('Email', group.email),
                            _buildInfoRow('Phone', group.contactNumber),
                            _buildInfoRow(
                              'Group Leader',
                              group.groupLeaderName,
                            ),
                          ]),
                          if (group.description != null) ...[
                            const SizedBox(height: 16),
                            _buildInfoSection('About', [
                              Text(group.description!),
                            ]),
                          ],
                          const SizedBox(height: 16),
                          _buildInfoSection('Team Members', [
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children:
                                  group.teamMembers.map((member) {
                                    return Chip(
                                      avatar: const CircleAvatar(
                                        child: Icon(Icons.person, size: 16),
                                      ),
                                      label: Text(
                                        '${member.name} (${member.phone})',
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ]),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                context,
                                'Approve',
                                Icons.check_circle,
                                Colors.green,
                                () {
                                  controller.updateGroupStatus(group.documentId, 'approved');
                                },
                              ),
                              _buildActionButton(
                                context,
                                'Reject',
                                Icons.cancel,
                                Colors.red,
                                () {
                                  controller.updateGroupStatus(group.documentId, 'rejected');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Chip(
                              label: Text(
                                group.status,
                                style: TextStyle(
                                  color: _getStatusTextColor(group.status),
                                ),
                              ),
                              backgroundColor: _getStatusChipColor(group.status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: ElevatedButton.styleFrom(backgroundColor: color.withOpacity(0.1)),
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1);
      case 'approved':
        return Colors.green.withOpacity(0.1);
      case 'rejected':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.transparent;
    }
  }

  Color _getStatusChipColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.withOpacity(0.2);
      case 'approved':
        return Colors.green.withOpacity(0.2);
      case 'rejected':
        return Colors.red.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade900;
      case 'approved':
        return Colors.green.shade900;
      case 'rejected':
        return Colors.red.shade900;
      default:
        return Colors.grey.shade900;
    }
  }
}
