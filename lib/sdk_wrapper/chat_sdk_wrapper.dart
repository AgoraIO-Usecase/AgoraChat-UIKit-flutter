// ignore_for_file: duplicate_export

library chat_sdk_wrapper;

import 'sdk_define.dart';

import 'package:flutter/material.dart';

import 'sdk_wrapper_defines.dart';
import 'observers/action_event_observer.dart';

import 'actions/chat_actions.dart';
import 'actions/group_actions.dart';
import 'actions/notification_actions.dart';
import 'actions/contact_actions.dart';
import 'actions/presence_actions.dart';
import 'actions/thread_actions.dart';
import 'actions/user_info_actions.dart';

import 'wrappers/chat_wrapper.dart';
import 'wrappers/connect_wrapper.dart';
import 'wrappers/contact_wrapper.dart';
import 'wrappers/group_wrapper.dart';
import 'wrappers/message_wrapper.dart';
import 'wrappers/multi_wrapper.dart';
import 'wrappers/presence_wrapper.dart';
import 'wrappers/notification_wrapper.dart';
import 'wrappers/thread_wrapper.dart';
import 'wrappers/user_info_wrapper.dart';

export 'actions/chat_actions.dart';
export 'actions/group_actions.dart';
export 'actions/notification_actions.dart';
export 'actions/contact_actions.dart';
export 'actions/presence_actions.dart';
export 'actions/thread_actions.dart';
export 'actions/user_info_actions.dart';

export 'sdk_define.dart';

export 'wrappers/chat_wrapper.dart';
export 'wrappers/connect_wrapper.dart';
export 'wrappers/contact_wrapper.dart';
export 'wrappers/group_wrapper.dart';
export 'wrappers/message_wrapper.dart';
export 'wrappers/multi_wrapper.dart';
export 'wrappers/presence_wrapper.dart';
export 'wrappers/notification_wrapper.dart';
export 'wrappers/thread_wrapper.dart';
export 'wrappers/user_info_wrapper.dart';

export 'observers/chat_observer.dart';
export 'observers/connect_observer.dart';
export 'observers/contact_observer.dart';
export 'observers/group_observer.dart';
export 'observers/message_observer.dart';
export 'observers/multi_observer.dart';
export 'observers/presence_observer.dart';
export 'observers/action_event_observer.dart';
export 'observers/thread_observer.dart';

export 'sdk_wrapper_defines.dart';
export 'sdk_define.dart';
export 'sdk_wrapper_defines.dart';
export 'sdk_wrapper_tools.dart';

const String sdkEventKey = 'chat_uikit';

abstract mixin class ChatUIKitObserverBase {}

abstract class ChatUIKitWrapperBase {
  @protected
  final List<ChatUIKitObserverBase> observers = [];

  @protected
  @mustCallSuper
  void addListeners() {}

  @protected
  @mustCallSuper
  void removeListeners() {}

  ChatUIKitWrapperBase() {
    addListeners();
  }

  void addObserver(ChatUIKitObserverBase observer) {
    observers.add(observer);
  }

  void removeObserver(ChatUIKitObserverBase observer) {
    observers.remove(observer);
  }

  @protected
  Future<T> checkResult<T>(
    ChatSDKEvent actionEvent,
    Future<T> Function() method,
  ) async {
    T result;
    ChatError? error;
    try {
      _onEventBegin(actionEvent);
      result = await method.call();
      return result;
    } on ChatError catch (e) {
      error = e;
      rethrow;
    } finally {
      _onEventEnd(actionEvent, error);
    }
  }

  void _onEventBegin(ChatSDKEvent event) {
    for (var observer in observers) {
      if (observer is ChatSDKEventsObserver) {
        observer.onChatSDKEventBegin(event);
      }
    }
  }

  void _onEventEnd(ChatSDKEvent event, ChatError? error) {
    for (var observer in observers) {
      if (observer is ChatSDKEventsObserver) {
        observer.onChatSDKEventEnd(event, error);
      }
    }
  }
}

class ChatSDKWrapper extends ChatUIKitWrapperBase
    with
        ChatWrapper,
        GroupWrapper,
        ContactWrapper,
        ConnectWrapper,
        MultiWrapper,
        MessageWrapper,
        NotificationWrapper,
        ThreadWrapper,
        PresenceWrapper,
        UserInfoWrapper,
        ChatActions,
        ContactActions,
        GroupActions,
        NotificationActions,
        ThreadActions,
        PresenceActions,
        UserInfoActions,
        ChatSDKEventsObserver {
  static ChatSDKWrapper? _instance;
  static ChatSDKWrapper get instance {
    return _instance ??= ChatSDKWrapper();
  }

  Future<void> init({
    required Options options,
  }) async {
    await Client.getInstance.init(options);
    Client.getInstance.startCallback();
  }

  /// Login with password
  ///
  /// Param [userId] : userId
  ///
  /// Param [password] : user password
  Future<void> loginWithPassword({
    required String userId,
    required String password,
  }) async {
    return checkResult(ChatSDKEvent.loginWithPassword, () async {
      await Client.getInstance.loginWithPassword(userId, password);
      await Client.getInstance.startCallback();
    });
  }

  /// Login with token
  ///
  /// Param [userId] : userId
  ///
  /// Param [token] : user token
  Future<void> loginWithToken({
    required String userId,
    required String token,
  }) {
    return checkResult(ChatSDKEvent.loginWithToken, () async {
      await Client.getInstance.loginWithToken(userId, token);
      await Client.getInstance.startCallback();
    });
  }

  /// Logout
  Future<void> logout() {
    return checkResult(ChatSDKEvent.logout, () async {
      await Client.getInstance.logout();
    });
  }

  /// Get current is logged
  ///
  /// Return: true is logged, false is not logged
  bool isLogged() {
    return Client.getInstance.currentUserId != null;
  }

  Future<bool> isConnect() => Client.getInstance.isConnected();

  /// Get current user id
  ///
  /// Return: current user id
  String? get currentUserId {
    return Client.getInstance.currentUserId;
  }
}
