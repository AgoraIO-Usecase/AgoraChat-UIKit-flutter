import '../agora_chat_uikit.dart';

class ChatUIKitError {
  static int noPermission = -10;
  static int recordTimeTooShort = -11;
  static int recordError = -12;

  static ChatError toChatError(int code, String desc) {
    return ChatError.fromJson({"code": code, "description": desc});
  }
}
