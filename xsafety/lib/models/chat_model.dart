class ChatModel {
  final String role;
  final String text;

  ChatModel({required this.role, required this.text});

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'parts': [{'text': text}]
    };
  }

  Map<String, dynamic> toDbMap(String emergencyType) {
    return {
      'role': role,
      'text': text,
      'emergencyType': emergencyType,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  static ChatModel fromDbMap(Map<String, dynamic> map) {
    return ChatModel(
      role: map['role'],
      text: map['text'],
    );
  }
}
