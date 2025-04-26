import 'package:get/get.dart';
import 'package:xsafety/core/chat_db_helper.dart';
import 'package:xsafety/core/chat_repo.dart';
import '../models/chat_model.dart';

class EmergencyChatController extends GetxController {
  final messages = <ChatModel>[].obs;
  final isLoading = false.obs;

  String currentEmergency = '';

  Future<void> loadChat(String emergencyType) async {
    currentEmergency = emergencyType;
    messages.value = await ChatDbHelper.getChats(emergencyType);
  }

  Future<void> sendMessage(String text) async {
    isLoading.value = true;

    final userMsg = ChatModel(role: 'user', text: text);
    messages.add(userMsg);
    await ChatDbHelper.insertChat(userMsg, currentEmergency);

    final responseText = await ChatRepo.chatTextGenerationRepo([
      ...messages,
    ]);

    final botMsg = ChatModel(role: 'model', text: responseText);
    messages.add(botMsg);
    await ChatDbHelper.insertChat(botMsg, currentEmergency);

    isLoading.value = false;
  }
}
