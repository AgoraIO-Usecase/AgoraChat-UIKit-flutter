import '../chat_sdk_wrapper.dart';

mixin NotificationActions on NotificationWrapper {
  Future<PushConfigs> fetchPushConfig() {
    return checkResult(ChatSDKEvent.fetchPushConfig, () {
      return Client.getInstance.pushManager.fetchPushConfigsFromServer();
    });
  }

  Future<void> uploadPushDisplayName({required displayName}) {
    return checkResult(ChatSDKEvent.uploadPushDisplayName, () {
      return Client.getInstance.pushManager.updatePushNickname(displayName);
    });
  }

  Future<void> updatePushDisplayStyle({required DisplayStyle style}) {
    return checkResult(ChatSDKEvent.updatePushDisplayStyle, () {
      return Client.getInstance.pushManager.updatePushDisplayStyle(style);
    });
  }

  Future<void> uploadHMSPushToken({required String token}) {
    return checkResult(ChatSDKEvent.uploadHMSPushToken, () {
      return Client.getInstance.pushManager.updateHMSPushToken(token);
    });
  }

  Future<void> uploadFCMPushToken({required String token}) {
    return checkResult(ChatSDKEvent.uploadFCMPushToken, () {
      return Client.getInstance.pushManager.updateFCMPushToken(token);
    });
  }

  Future<void> uploadAPNsPushToken({required String token}) {
    return checkResult(ChatSDKEvent.uploadAPNsPushToken, () {
      return Client.getInstance.pushManager.updateAPNsDeviceToken(token);
    });
  }

  Future<void> setSilentMode({
    required String conversationId,
    required ConversationType type,
    required ChatSilentModeParam param,
  }) {
    return checkResult(ChatSDKEvent.setSilentMode, () {
      return Client.getInstance.pushManager.setConversationSilentMode(
        conversationId: conversationId,
        type: type,
        param: param,
      );
    });
  }

  Future<void> clearSilentMode({
    required String conversationId,
    required ConversationType type,
  }) {
    return checkResult(ChatSDKEvent.clearSilentMode, () {
      return Client.getInstance.pushManager.removeConversationSilentMode(
        conversationId: conversationId,
        type: type,
      );
    });
  }

  Future<Map<String, ChatSilentModeResult>> fetchSilentModel({
    required List<Conversation> conversations,
  }) {
    return checkResult(ChatSDKEvent.fetchSilentModel, () {
      return Client.getInstance.pushManager
          .fetchSilentModeForConversations(conversations);
    });
  }

  Future<void> setAllSilentMode({required ChatSilentModeParam param}) {
    return checkResult(ChatSDKEvent.setAllSilentMode, () {
      return Client.getInstance.pushManager.setSilentModeForAll(param: param);
    });
  }
}
