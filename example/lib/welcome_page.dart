import 'package:agora_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with ChatUIKitThemeMixin {
  @override
  void initState() {
    super.initState();
    startShowTimer();
  }

  void startShowTimer() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      return ChatUIKit.instance.isLoginBefore();
    }).then((value) {
      if (value) {
        toHomePage();
      } else {
        toLoginPage();
      }
    });
  }

  void toHomePage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void toLoginPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return Scaffold(
      backgroundColor: theme.color.primaryColor95,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/chat/icon.png'),
              ),
              const SizedBox(height: 38),
              const SizedBox(height: 180),
            ],
          ),
        ],
      ),
    );
  }
}
