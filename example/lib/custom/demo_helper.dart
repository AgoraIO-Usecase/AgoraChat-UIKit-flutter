import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DemoHelper {
  static List<String> blockList = [];

  static Future<void> fetchBlockList() async {
    blockList.clear();
    List<String> list = await ChatUIKit.instance.fetchAllBlockedContactIds();
    blockList.addAll(list);
  }

  static Future<void> blockUsers(String userId, bool add) async {
    try {
      EasyLoading.show();
      if (add) {
        await ChatUIKit.instance.addBlockedContact(userId: userId);
      } else {
        await ChatUIKit.instance.deleteBlockedContact(userId: userId);
      }
      updateBlockList(userId, add);
    } catch (e) {
      EasyLoading.showError(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  static void updateBlockList(String userId, bool add) {
    if (add) {
      blockList.add(userId);
    } else {
      blockList.remove(userId);
    }
  }
}
