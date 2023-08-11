import '../agora_chat_uikit.dart';
import 'chat_message_list_manager.dart';
import 'chat_method.dart';

class ChatUIKitManager {
  static ChatUIKitManager? _shared;

  static ChatUIKitManager get shared => _shared ??= ChatUIKitManager._();

  static void clear() {
    _shared?._removeListeners();
    _shared = null;
  }

  final String _chatHandlerKey = '_chatHandlerKey';
  final String _connectionHandlerKey = '_connectionHandlerKey';
  final String _multiDeviceHandlerKey = '_multiDeviceHandlerKey';

  ChatMessageListCallback? messageListManager;

  ChatUIKitManager._() {
    _addListeners();
    chatClient.startCallback();
  }

  void _addListeners() {
    chatClient.chatManager.addEventHandler(
      _chatHandlerKey,
      ChatEventHandler(
        onMessagesReceived: _onMessagesReceived,
        onCmdMessagesReceived: _onCmdMessagesReceived,
        onMessagesRead: _onMessagesRead,
        onGroupMessageRead: _onGroupMessageRead,
        onReadAckForGroupMessageUpdated: _onReadAckForGroupMessageUpdated,
        onMessagesDelivered: _onMessagesDelivered,
        onMessagesRecalled: _onMessagesRecalled,
        onConversationsUpdate: _onConversationsUpdate,
        onConversationRead: _onConversationRead,
        onMessageReactionDidChange: _onMessageReactionDidChange,
      ),
    );

    chatClient.addConnectionEventHandler(
      _connectionHandlerKey,
      ConnectionEventHandler(),
    );

    chatClient.addMultiDeviceEventHandler(
      _multiDeviceHandlerKey,
      ChatMultiDeviceEventHandler(),
    );
  }

  void _removeListeners() {
    chatClient.chatManager.removeEventHandler(_chatHandlerKey);
    chatClient.removeConnectionEventHandler(_connectionHandlerKey);
    chatClient.removeMultiDeviceEventHandler(_multiDeviceHandlerKey);
  }

  void _onMessagesReceived(List<ChatMessage> messages) {
    messageListManager?.onMessagesReceived(messages);
  }

  void _onMessagesRead(List<ChatMessage> messages) {
    messageListManager?.onMessagesRead(messages);
  }

  void _onMessagesDelivered(List<ChatMessage> messages) {
    messageListManager?.onMessagesDelivered(messages);
  }

  void _onMessagesRecalled(List<ChatMessage> messages) {
    messageListManager?.onMessagesRecalled(messages);
  }

  void _onGroupMessageRead(List<ChatGroupMessageAck> acks) {
    messageListManager?.onGroupMessageRead(acks);
  }

  void _onReadAckForGroupMessageUpdated() {
    messageListManager?.onReadAckForGroupMessageUpdated();
  }

  void _onCmdMessagesReceived(List<ChatMessage> messages) {
    messageListManager?.onCmdMessagesReceived(messages);
  }

  void _onConversationsUpdate() {
    messageListManager?.onConversationsUpdate();
  }

  void _onConversationRead(String from, String to) {
    messageListManager?.onConversationRead(from, to);
  }

  void _onMessageReactionDidChange(List<ChatMessageReactionEvent> events) {
    messageListManager?.onMessageReactionDidChange(events);
  }
}
