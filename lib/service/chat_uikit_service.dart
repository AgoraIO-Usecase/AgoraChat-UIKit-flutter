import '../../chat_uikit.dart';
import 'actions/chat_uikit_chat_actions.dart';
import 'actions/chat_uikit_contact_actions.dart';
import 'actions/chat_uikit_events_actions.dart';
import 'actions/chat_uikit_notification_actions.dart';
import 'observers/chat_uikit_chat_observers.dart';

import '../../service/observers/chat_uikit_contact_observers.dart';
import 'package:flutter/widgets.dart';

class ChatUIKit extends ChatSDKWrapper
    with
        ChatUIKitChatActions,
        ChatUIKitContactActions,
        ChatUIKitEventsActions,
        ChatUIKitNotificationActions,
        ChatUIKitChatObservers,
        ChatUIKitContactObservers,
        ChatUIKitEventsObservers {
  static ChatUIKit? _instance;
  static ChatUIKit get instance {
    WidgetsFlutterBinding.ensureInitialized();
    return _instance ??= ChatUIKit();
  }

  ChatUIKit() : super() {
    ChatUIKitContext.instance;
  }

  Options? _options;
  Options? get options => _options;

  @override
  Future<void> init({required Options options}) async {
    _options = options;
    await super.init(options: options);
    ChatUIKitContext.instance.currentUserId = currentUserId;
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
      ChatUIKitContext.instance.currentUserId = userId;
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
      ChatUIKitContext.instance.currentUserId = userId;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await super.logout();
      ChatUIKitContext.instance.currentUserId = null;
      ChatUIKitProvider.instance.clearAllCache();
    } catch (e) {
      rethrow;
    }
  }

  int contactRequestCount() {
    return ChatUIKitContext.instance.newRequestCount();
  }
}
