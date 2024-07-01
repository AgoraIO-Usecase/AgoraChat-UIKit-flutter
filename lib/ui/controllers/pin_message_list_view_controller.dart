import '../../chat_uikit.dart';
import 'package:flutter/foundation.dart';

class PinMessageListViewController extends ChangeNotifier
    with ChatObserver, ChatUIKitProviderObserver {
  PinMessageListViewController(this.profile) {
    ChatUIKit.instance.addObserver(this);
    ChatUIKitProvider.instance.addObserver(this);
  }

  final ChatUIKitProfile profile;
  bool needReload = false;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  bool isShow = false;

  ValueNotifier<List<PinListItemModel>> list = ValueNotifier([]);

  void show() {
    if (list.value.isEmpty) return;
    isShow = true;
    if (hasListeners) notifyListeners();
  }

  void hide() {
    isShow = false;
    notifyListeners();
  }

  Future<void> pinMsg(Message message) async {
    try {
      await ChatUIKit.instance.pinMessage(messageId: message.msgId);
      MessagePinInfo? info = await message.pinInfo();
      list.value = [PinListItemModel(message: message, pinInfo: info!)] +
          list.value.toList();
    } catch (e) {
      debugPrint('Error pinning message: $e');
    }
  }

  Future<void> unPinMsg(String msgId) async {
    try {
      await ChatUIKit.instance.unpinMessage(messageId: msgId);
      List<PinListItemModel> models = list.value.toList();
      models.removeWhere((element) => element.message.msgId == msgId);
      list.value = models;
    } catch (e) {
      debugPrint('Error unpinning message: $e');
    }
  }

  bool isFetching = false;
  Future<void> fetchPinMessages() async {
    if (isFetching || isShow) return;
    isFetching = true;
    try {
      final messages = await ChatUIKit.instance.fetchPinnedMessages(
        conversationId: profile.id,
      );
      List<PinListItemModel> items = [];

      for (var msg in messages) {
        MessagePinInfo? pinInfo = await msg.pinInfo();
        if (pinInfo == null) continue;
        items.add(PinListItemModel(message: msg, pinInfo: pinInfo));
      }

      if (items.isNotEmpty) {
        list.value = items;
        show();
      }
    } catch (e) {
      debugPrint('Error fetching pinned messages: $e');
    }
    isFetching = false;
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    List<PinListItemModel> models = list.value.toList();
    List<String> updateIds = map.keys.toList();

    needReload = updateIds.any(
      (element) => models.any((model) =>
          model.message.from == element || model.pinInfo.operatorId == element),
    );
    if (needReload) {
      notifyListeners();
      needReload = false;
    }
  }

  @override
  void onMessagePinChanged(
    String messageId,
    String conversationId,
    MessagePinOperation pinOperation,
    MessagePinInfo pinInfo,
  ) async {
    List<PinListItemModel> models = list.value.toList();
    models.removeWhere((element) => element.message.msgId == messageId);
    if (pinOperation == MessagePinOperation.Pin) {
      Message? msg = await ChatUIKit.instance.loadMessage(messageId: messageId);
      if (msg != null) {
        models.insert(0, PinListItemModel(message: msg, pinInfo: pinInfo));
        list.value = models;
      }
    } else {
      list.value = models;
    }
  }

  @override
  void onMessagesRecalled(List<Message> recalled, List<Message> replaces) {
    List<PinListItemModel> models = list.value.toList();
    int index = models.indexWhere(
        (element) => recalled.any((msg) => msg.msgId == element.message.msgId));
    if (index != -1) {
      models.removeAt(index);
      list.value = models;
    }
  }
}
