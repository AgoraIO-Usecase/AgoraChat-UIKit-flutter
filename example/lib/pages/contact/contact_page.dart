import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/custom/demo_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  void initState() {
    super.initState();
    DemoHelper.fetchBlockList();
  }

  @override
  Widget build(BuildContext context) {
    return const ContactsView();
  }
}
