import 'dart:convert';

import 'chat_uikit.dart';
import 'universal/inner_headers.dart';

const String convLoadFinishedKey =
    'EaseChatUIKit_conversation_load_more_finished';
const String contactLoadFinishedKey =
    'EaseChatUIKit_contact_load_more_finished';
const String muteMapKey = 'EaseChatUIKit_conversation_mute_map';
const String requestsKey = 'EaseChatUIKit_friend_requests';

class ChatUIKitContext {
  late SharedPreferences sharedPreferences;
  String? _currentUserId;

  Map<String, dynamic> cachedMap = {};
  // 缓存，不存db；
  bool _hasFetchedContacts = false;

  static ChatUIKitContext? _instance;
  static ChatUIKitContext get instance {
    return _instance ??= ChatUIKitContext._internal();
  }

  set currentUserId(String? userId) {
    if (_currentUserId != userId) {
      cachedMap.clear();
    }
    _currentUserId = userId;
    if (_currentUserId?.isNotEmpty == true) {
      String? cache = sharedPreferences.getString(_currentUserId!);
      if (cache != null) {
        cachedMap = json.decode(cache);
      }
    }
  }

  ChatUIKitContext._internal() {
    init();
  }

  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _updateStore() {
    sharedPreferences.setString(_currentUserId!, json.encode(cachedMap));
  }
}

extension Request on ChatUIKitContext {
  List requestList() {
    return cachedMap[requestsKey] ?? [];
  }

  int newRequestCount() {
    int count = 0;
    cachedMap[requestsKey]?.forEach((element) {
      if (!element['isRead']) {
        count++;
      }
    });
    return count;
  }

  void markAllRequestsAsRead() {
    List requestList = cachedMap[requestsKey] ?? [];
    bool hasUnread = false;
    for (var element in requestList) {
      if (element['isRead'] == false) {
        hasUnread = true;
      }
      element['isRead'] = true;
    }
    cachedMap[requestsKey] = requestList;
    if (hasUnread) {
      ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    }

    _updateStore();
  }

  bool addRequest(String userId, String? reason, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    if (requestList.any((element) =>
        element['id'] == userId && element['isGroup'] == isGroup)) {
      return false;
    }
    requestList.add({
      'id': userId,
      'reason': reason,
      'isGroup': isGroup,
      'isRead': false,
    });
    cachedMap[requestsKey] = requestList;
    ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
    _updateStore();
    return true;
  }

  void removeRequest(String userId, [bool isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    int index = requestList.indexWhere(
        (element) => element['id'] == userId && element['isGroup'] == isGroup);
    if (index != -1) {
      Map ret = requestList.removeAt(index);
      if (ret.containsKey('isRead') && !ret['isRead']) {
        ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
      }
      cachedMap[requestsKey] = requestList;
      _updateStore();
    }
  }

  void removeRequests(List<String> userIds, [isGroup = false]) {
    List requestList = cachedMap[requestsKey] ?? [];
    bool needUpdate = false;
    for (var userId in userIds) {
      int index = requestList.indexWhere((element) =>
          element['id'] == userId && element['isGroup'] == isGroup);
      bool hasUnread = false;
      if (index != -1) {
        needUpdate = true;
        Map ret = requestList.removeAt(index);
        if (ret.containsKey('isRead') && !ret['isRead']) {
          hasUnread = true;
        }
      }
      if (hasUnread) {
        ChatUIKit.instance.onFriendRequestCountChanged(newRequestCount());
      }
    }
    if (needUpdate) {
      cachedMap[requestsKey] = requestList;
      _updateStore();
    }
  }
}

extension ContactLoad on ChatUIKitContext {
  bool isContactLoadFinished() {
    return _hasFetchedContacts;
  }

  void setContactLoadFinished() {
    _hasFetchedContacts = true;
  }
}

extension ConversationFirstLoad on ChatUIKitContext {
  bool isConversationLoadFinished() {
    return cachedMap[convLoadFinishedKey] ??= false;
  }

  void setConversationLoadFinished() {
    cachedMap[convLoadFinishedKey] = true;
    _updateStore();
  }
}

extension ConversationMute on ChatUIKitContext {
  void addConversationMute(Map<String, int> map) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    tmpMap.addAll(map);
    cachedMap[muteMapKey] = tmpMap;
    _updateStore();
  }

  bool conversationIsMute(String conversationId) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    return tmpMap?.containsKey(conversationId) ?? false;
  }

  void deleteConversationMute(List<String> list) {
    dynamic tmpMap = cachedMap[muteMapKey] ?? {};
    for (var element in list) {
      tmpMap.remove(element);
    }
    cachedMap[muteMapKey] = tmpMap;
    _updateStore();
  }
}
