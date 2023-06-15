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
      appBar: AppBar(
        title: const Text('ConversationPage'),
      ),
      body: ChatConversationsView(
        onItemTap: (conversation) {
          SnackBar bar = SnackBar(
            content: Text('${conversation.id} clicked'),
            duration: const Duration(milliseconds: 1000),
          );
          ScaffoldMessenger.of(context).showSnackBar(bar);
        },
      ),
    );
  }
}
