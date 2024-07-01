import '../chat_uikit.dart';

extension ConversationHelp on Conversation {
  Future<void> addMention() async {
    Map<String, String> conversationExt = ext ?? {};
    conversationExt[hasMentionKey] = hasMentionValue;
    await setExt(conversationExt);
  }

  Future<void> removeMention() async {
    if (ext != null && ext?[hasMentionKey] != null) {
      ext?.remove(hasMentionKey);
      await setExt(ext);
    }
  }
}
