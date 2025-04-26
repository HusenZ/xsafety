class TeamMember {
  final String name;
  final String phone;
  final String uid;

  TeamMember({
    required this.name,
    required this.phone,
    required this.uid,
  });

  factory TeamMember.fromMap(Map<String, dynamic> map) {
    return TeamMember(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      uid: map['uid'] ?? '',
    );
  }
}

class RescuerGroup {
  final String groupName;
  final String state;
  final String email;
  final String contactNumber;
  final String groupLeaderName;
  final String? description;
  final List<TeamMember> teamMembers;
  final String status;
  final String documentId;

  RescuerGroup({
    required this.groupName,
    required this.state,
    required this.email,
    required this.contactNumber,
    required this.groupLeaderName,
    required this.description,
    required this.teamMembers,
    required this.status,
    required this.documentId,
  });

  factory RescuerGroup.fromDoc(String docId, Map<String, dynamic> map) {
    return RescuerGroup(
      documentId: docId,
      groupName: map['groupName'] ?? '',
      state: map['state'] ?? '',
      email: map['email'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      groupLeaderName: map['groupLeaderName'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'pending',
      teamMembers: List<TeamMember>.from(
        (map['teamMembers'] as List<dynamic>?)
                ?.map((e) => TeamMember.fromMap(e)) ??
            [],
      ),
    );
  }
}
