import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_service/actions/chat_uikit_room_actions.dart';

import '../../../chat_sdk_context/chat_sdk_context.dart';

import '../../../../chat_uikit.dart';
import 'actions/chat_uikit_chat_actions.dart';
import 'actions/chat_uikit_contact_actions.dart';
import 'actions/chat_uikit_events_actions.dart';
import 'actions/chat_uikit_group_actions.dart';
import 'actions/chat_uikit_notification_actions.dart';

import 'observers/chat_uikit_chat_observers.dart';
import 'observers/chat_uikit_contact_observers.dart';
import 'observers/chat_uikit_group_observers.dart';
import 'observers/chat_uikit_multi_observers.dart';
import 'observers/chat_uikit_thread_observers.dart';
import 'package:flutter/widgets.dart';

class ChatUIKit extends ChatSDKService
    with
        ChatUIKitChatActions,
        ChatUIKitContactActions,
        ChatUIKitGroupActions,
        ChatUIKitEventsActions,
        ChatUIKitRoomActions,
        ChatUIKitNotificationActions,
        ChatUIKitChatObservers,
        ChatUIKitGroupObservers,
        ChatUIKitContactObservers,
        ChatUIKitMultiObservers,
        ChatUIKitThreadObservers,
        ChatUIKitEventsObservers {
  static ChatUIKit? _instance;
  static ChatUIKit get instance {
    WidgetsFlutterBinding.ensureInitialized();
    return _instance ??= ChatUIKit();
  }

  ChatUIKit() : super() {
    ChatSDKContext.instance;
  }

  Options? _options;
  Options? get options => _options;

  @override
  Future<void> init({required Options options}) async {
    _options = options;
    await super.init(options: options);
    ChatSDKContext.instance.setUserId(currentUserId);
  }

  /// Login
  ///
  /// Param [userId] : userId
  ///
  /// Param [password] : user password
  @override
  Future<void> loginWithPassword({
    required String userId,
    required String password,
  }) async {
    try {
      await super.loginWithPassword(userId: userId, password: password);
      ChatSDKContext.instance.setUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> loginWithToken({
    required String userId,
    required String token,
  }) async {
    try {
      await super.loginWithToken(userId: userId, token: token);
      ChatSDKContext.instance.setUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await super.logout();
      ChatSDKContext.instance.setUserId(null);
      ChatUIKitProvider.instance.clearAllCache();
    } catch (e) {
      rethrow;
    }
  }
}
