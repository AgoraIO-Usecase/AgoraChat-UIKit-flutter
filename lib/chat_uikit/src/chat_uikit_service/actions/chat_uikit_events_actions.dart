import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';

mixin ChatUIKitEventsActions on ChatSDKService {
  void sendChatUIKitEvent(ChatUIKitEvent event) {
    for (var element in observers) {
      if (element is ChatUIKitEventsObservers) {
        element.onChatUIKitEventsReceived(event);
      }
    }
  }
}
