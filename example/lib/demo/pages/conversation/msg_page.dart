import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget(this.profile, {super.key});
  final ChatUIKitProfile profile;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with ChatUIKitThemeMixin {
  late final ChatUIKitKeyboardPanelController keyboardPanelController;
  late final MessagesViewController messageController;
  @override
  void initState() {
    super.initState();
    keyboardPanelController = ChatUIKitKeyboardPanelController(
      inputTextEditingController: CustomTextEditingController(),
    );
    messageController = MessagesViewController(profile: widget.profile);
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    ChatUIKitSettings.messageLongPressMenuStyle =
        ChatUIKitMessageLongPressMenuStyle.popupMenu;
    return MessagesView(
      profile: widget.profile,
      // controller: messageController,
      // inputController: keyboardPanelController,
      // backgroundWidget: Container(
      //   color: Colors.red,
      // ),
      // inputBar: ChatUIKitInputBar(
      //   keyboardPanelController: keyboardPanelController,
      //   maintainBottomViewPadding: true,
      //   rightItems: [
      //     InkWell(
      //       onTap: () async {
      //         if (keyboardPanelController.currentPanelType ==
      //             ChatUIKitKeyboardPanelType.emoji) {
      //           keyboardPanelController.switchPanel(
      //             ChatUIKitKeyboardPanelType.keyboard,
      //           );
      //         } else {
      //           keyboardPanelController.switchPanel(
      //             ChatUIKitKeyboardPanelType.emoji,
      //           );
      //         }
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.all(4),
      //         child: ChatUIKitImageLoader.faceKeyboard(
      //           color: theme.color.isDark
      //               ? theme.color.neutralColor5
      //               : theme.color.neutralColor3,
      //         ),
      //       ),
      //     ),
      //     InkWell(
      //       onTap: () {
      //         final text = keyboardPanelController
      //             .inputTextEditingController.text
      //             .trim();
      //         if (text.isEmpty) {
      //           return;
      //         }
      //         messageController.sendTextMessage(text);
      //         keyboardPanelController.inputTextEditingController.clear();
      //       },
      //       child: const Padding(
      //         padding: EdgeInsets.all(4),
      //         child: SizedBox(
      //           height: 30,
      //           width: 30,
      //           child: Icon(Icons.send),
      //         ),
      //       ),
      //     ),
      //   ],
      //   bottomPanels: [
      //     const ChatUIKitBottomPanelData(
      //       height: 0,
      //       panelType: ChatUIKitKeyboardPanelType.keyboard,
      //     ),
      //     ChatUIKitBottomPanelData(
      //         height: 230,
      //         showCursor: true,
      //         panelType: ChatUIKitKeyboardPanelType.emoji,
      //         child: Container(
      //           height: 230,
      //           color: Colors.blue,
      //         )),
      //   ],
      //   leftItems: [
      //     InkWell(
      //       onTap: () async {
      //         keyboardPanelController
      //             .switchPanel(ChatUIKitKeyboardPanelType.none);
      //         RecordResultData? data = await showChatUIKitRecordBar(
      //           context: context,
      //           backgroundColor: theme.color.isDark
      //               ? theme.color.neutralColor1
      //               : theme.color.neutralColor98,
      //         );
      //         if (data != null) {
      //           final msg = Message.createVoiceSendMessage(
      //               targetId: widget.profile.id,
      //               filePath: data.path!,
      //               duration: data.duration ?? 0,
      //               chatType: () {
      //                 if (widget.profile.type == ChatUIKitProfileType.contact) {
      //                   return ChatType.Chat;
      //                 } else {
      //                   return ChatType.GroupChat;
      //                 }
      //               }());
      //           messageController.sendMessage(msg);
      //         }
      //       },
      //       child: Padding(
      //         padding: const EdgeInsets.all(4),
      //         child: ChatUIKitImageLoader.voiceKeyboard(
      //           color: theme.color.isDark
      //               ? theme.color.neutralColor5
      //               : theme.color.neutralColor3,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
