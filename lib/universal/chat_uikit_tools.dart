import '../chat_uikit.dart';

class ChatUIKitTools {
  static List<Message> tmpCreateThreadMessages({
    required ChatThread thread,
  }) {
    String eventKey = '';
    String? operator = thread.owner;

    eventKey = alertCreateThreadKey;
    int time = thread.createAt;
    Message timeMsg = Message.createCustomSendMessage(
      targetId: thread.parentId,
      event: alertTimeKey,
      chatType: ChatType.GroupChat,
    );
    timeMsg.serverTime = time;
    timeMsg.localTime = time;
    timeMsg.status = MessageStatus.SUCCESS;

    Message alertMsg = Message.createCustomSendMessage(
      targetId: thread.parentId,
      event: eventKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: operator ?? '',
      },
    );

    alertMsg.conversationId = thread.parentId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    return [timeMsg, alertMsg];
  }
}
