import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xsafety/controllers/chat_controller.dart';

class EmergencyChatScreen extends StatefulWidget {
  final String emergencyType;

  const EmergencyChatScreen({super.key, required this.emergencyType});

  @override
  State<EmergencyChatScreen> createState() => _EmergencyChatScreenState();
}

class _EmergencyChatScreenState extends State<EmergencyChatScreen> {
  final controller = Get.put(EmergencyChatController());

  final _msgController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
    controller.loadChat(widget.emergencyType); // AFTER widget tree is ready
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.loadChat(widget.emergencyType);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.emergencyType} Help Chat'),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final msg = controller.messages[index];
                final isUser = msg.role == 'user';
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(msg.text, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            )),
          ),
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : const SizedBox()),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.redAccent),
                  onPressed: () {
                    if (_msgController.text.trim().isNotEmpty) {
                      controller.sendMessage(_msgController.text.trim());
                      _msgController.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
