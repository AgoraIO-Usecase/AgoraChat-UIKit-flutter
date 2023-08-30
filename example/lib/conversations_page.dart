import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

import 'messages_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final ChatConversationsController controller = ChatConversationsController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConversationPage'),
      ),
      body: ChatConversationsView(
        conversationsController: controller,
        onItemTap: (conversation) {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => MessagesPage(conversation)))
              .then((value) {
            controller.loadAllConversations();
          });
        },
      ),
    );
  }
}
