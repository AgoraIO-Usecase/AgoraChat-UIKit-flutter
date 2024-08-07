import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DebugLoginPage extends StatefulWidget {
  const DebugLoginPage({super.key});

  @override
  State<DebugLoginPage> createState() => _DebugLoginPageState();
}

class _DebugLoginPageState extends State<DebugLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppKey: $appKey'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('If AppKey is not set, set it in main.dart'),
            const Text('userId: $userId'),
            const Text('token: $token'),
            ElevatedButton(
              onPressed: () {
                if (userId.isNotEmpty && token.isNotEmpty) {
                  loginWithToken();
                } else {
                  showDialog(context);
                }
                showDialog(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDialog(BuildContext context) async {
    List<ChatUIKitDialogAction> list = [];
    list.add(
      ChatUIKitDialogAction.cancel(
        label: 'Cancel',
        onTap: () async {
          Navigator.of(context).pop();
        },
      ),
    );
    list.add(
      ChatUIKitDialogAction.inputsConfirm(
        label: 'Confirm',
        onInputsTap: (List<String> inputs) async {
          Navigator.of(context).pop(inputs);
        },
      ),
    );

    dynamic ret = await showChatUIKitDialog(
      context: context,
      inputItems: [
        ChatUIKitDialogInputContentItem(
          hintText: 'UserId',
          maxLength: 32,
        ),
        ChatUIKitDialogInputContentItem(
          hintText: 'Password',
        ),
      ],
      actionItems: list,
    );

    if (ret != null) {
      login((ret as List<String>).first, ret.last);
    }
  }

  void loginWithToken() async {
    EasyLoading.show(status: 'Loading...');
    ChatUIKit.instance
        .loginWithToken(userId: userId, token: token)
        .then((value) {
      toHomePage();
    }).catchError((e) {
      EasyLoading.showError(e.toString());
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void login(String userId, String password) async {
    EasyLoading.show(status: 'Loading...');
    ChatUIKit.instance
        .loginWithPassword(userId: userId, password: password)
        .then((value) {
      toHomePage();
    }).catchError((e) {
      EasyLoading.showError(e.toString());
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }

  void toHomePage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
