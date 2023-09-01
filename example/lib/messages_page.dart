import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(this.conversation, {super.key});

  final ChatConversation conversation;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
      ),
      body: SafeArea(
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
        ),
      ),
    );
  }
}
