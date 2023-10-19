import 'package:example/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversations")),
      // Conversation view page in uikit
      body: ChatConversationsView(
        // Click to jump to the message page.
        onItemTap: (conversation) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return MessagesPage(conversation);
              },
            ),
          );
        },
      ),
    );
  }
}
