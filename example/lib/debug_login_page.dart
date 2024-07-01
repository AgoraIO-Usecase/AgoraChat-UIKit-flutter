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
        title: const Text('当前AppKey: $appKey'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('如果没有设置Appkey，请在main.dart中设置'),
            ElevatedButton(
              onPressed: () {
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
    List<ChatUIKitDialogItem> list = [];
    list.add(
      ChatUIKitDialogItem.cancel(
        label: 'Cancel',
        onTap: () async {
          Navigator.of(context).pop();
        },
      ),
    );
    list.add(
      ChatUIKitDialogItem.inputsConfirm(
        label: 'Confirm',
        onInputsTap: (List<String> inputs) async {
          Navigator.of(context).pop(inputs);
        },
      ),
    );

    dynamic ret = await showChatUIKitDialog(
      context: context,
      hintsText: [
        'UserId',
        'Password',
      ],
      items: list,
    );

    if (ret != null) {
      login((ret as List<String>).first, ret.last);
    }
  }

  void login(String userId, String password) async {
    EasyLoading.show(status: 'Loading...');
    ChatUIKit.instance
        .loginWithPassword(userId: userId, password: password)
        .then((value) {
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((e) {
      EasyLoading.showError(e.toString());
    }).whenComplete(() {
      EasyLoading.dismiss();
    });
  }
}
