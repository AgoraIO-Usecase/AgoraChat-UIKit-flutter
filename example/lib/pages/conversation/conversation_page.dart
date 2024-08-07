import 'package:agora_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

/*
class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return const ConversationsView();
  }
}
*/

class _ConversationPageState extends State<ConversationPage> {
  late ConversationListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = ConversationListViewController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ConversationsView();
  }
}
