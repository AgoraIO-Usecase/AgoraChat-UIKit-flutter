import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/demo_localizations.dart';

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
        toSampleDemoPage();
      } else {
        toLoginPage();
      }
    });
  }

  void toSampleDemoPage() {
    Navigator.of(context).pushReplacementNamed('/sample_demo');
  }

  void toLoginPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
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
                child: Image.asset('assets/images/icon.png'),
              ),
              const SizedBox(height: 38),
              Text(
                DemoLocalizations.welcome.localString(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: theme.color.primaryColor5,
                ),
              ),
              const SizedBox(height: 180),
            ],
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              'Powered by Easemob',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.color.neutralColor5),
            ),
          )
        ],
      ),
    );
  }
}
