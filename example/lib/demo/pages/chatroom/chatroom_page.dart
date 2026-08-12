import 'dart:convert';

import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage(this.room, {super.key});

  final ChatRoom room;
  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>
    with RoomObserver, ChatUIKitThemeMixin {
  RoomInputBarController inputBarController = RoomInputBarController();

  // 发送礼物列表 使用
  List<ChatroomGiftPageController> controllers = [];
  String get roomId => widget.room.roomId;
  bool isOwner = false;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    analysisGiftList();
    setup();
    isOwner = widget.room.owner == ChatUIKit.instance.currentUserId;
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void setup() async {
    // 先获取自己的信息，之后再加入聊天室
    await setupMyInfo("加入昵称");
    joinChatRoom();
  }

  // 加入聊天室
  void joinChatRoom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatUIKit.instance.joinChatRoom(roomId: roomId).then((_) {
        debugPrint('join chat room');
      }).catchError((e) {
        EasyLoading.showError('加入失败');
        debugPrint('join chat room error: $e');
      });
    });
  }

  // 解析礼物列表
  Future<void> analysisGiftList() async {
    String giftJson = await rootBundle.loadString('assets/Gifts.json');
    Map<String, dynamic> map = json.decode(giftJson);
    for (var element in map.keys.toList()) {
      final controller = ChatroomGiftPageController(
        title: element,
        gifts: () {
          List<ChatRoomGift> list = [];
          map[element].forEach((element) {
            ChatRoomGift gift = ChatRoomGift.fromJson(element);
            list.add(gift);
          });
          return list;
        }(),
      );
      controllers.add(controller);
    }
  }

  // 设置自己在聊天室中的信息
  Future<void> setupMyInfo(String showName) async {
    ChatUIKitProfile profile = ChatRoomUserInfo.createUserProfile(
        userId: ChatUIKit.instance.currentUserId!,
        nickname: showName,
        ext: {"testKey": "testValue"});
    ChatUIKitProvider.instance.addProfiles([profile], roomId);
  }

  @override
  void onRemovedFromChatRoom(String roomId, String? roomName,
      String? participant, LeaveReason? reason) {
    if (roomId == widget.room.roomId) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    // 预加暗色载背景图片,防止切换时闪屏
    precacheImage(const AssetImage('assets/room/dark_bg.png'), context);
    Widget content = Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              inputBarController.hiddenInputBar();
            },
            child: Image.asset(
              theme.color.isDark
                  ? 'assets/room/dark_bg.png'
                  : 'assets/room/light_bg.png',
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).viewInsets.top + 10,
          left: 0,
          right: 0,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20, child: ChatRoomGlobalMessageWidget()),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          height: 84,
          bottom: 300,
          child: ChatRoomShowGiftView(roomId: roomId),
        ),
        Positioned(
          left: 16,
          right: 78,
          height: 204,
          bottom: 90,
          child: ChatRoomMessagesWidget(
            roomId: roomId,
            itemBuilder: (ctx, msg, user) {
              return null;
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 40,
          child: ChatRoomInputBar(
            bottomDistance: 40,
            controller: inputBarController,
            onSend: (msg) {
              if (msg.trim().isEmpty) {
                return;
              }
              ChatUIKit.instance.sendMessage(
                message: ChatRoomMessage.roomMessage(roomId, msg),
              );
            },
            actions: [
              InkWell(
                onTap: () async {
                  ChatRoomGift? gift = await showRoomGiftsView(
                    context,
                    giftControllers: controllers,
                  );
                  if (gift != null) {
                    ChatUIKit.instance.sendMessage(
                      message: ChatRoomMessage.giftMessage(roomId, gift),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Image.asset('assets/room/send_gift.png'),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    content = Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: ChatUIKitAppBar(
        showBackButton: false,
        leadingActions: [
          ChatUIKitAppBarAction(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: theme.color.isDark ? Colors.white38 : Colors.white70,
              ),
            ),
            onTap: (context) {
              Navigator.of(context).pop();
            },
          )
        ],
        backgroundColor: Colors.transparent,
        trailingActions: [
          ChatUIKitAppBarAction(
            child: IconButton(
              onPressed: () {
                setupMyInfo('新昵称');
              },
              icon: Icon(
                Icons.face,
                color: theme.color.isDark ? Colors.white38 : Colors.white70,
              ),
            ),
          ),
          ChatUIKitAppBarAction(
              child: IconButton(
            onPressed: () {
              // 发送自定义消息
              final msg = ChatRoomMessage.customMessage(
                roomId,
                "testEvent",
              );
              ChatUIKit.instance.sendMessage(message: msg);
            },
            icon: Icon(
              Icons.email,
              color: theme.color.isDark ? Colors.white38 : Colors.white70,
            ),
          )),
          ChatUIKitAppBarAction(
              child: IconButton(
            onPressed: () {
              showRoomMembersView(context, roomId: roomId, membersControllers: [
                ChatUIKitRoomMembersController(
                  '聊天室成员',
                  itemBuilder: (context, profile, onMoreAction) {
                    return ChatRoomUIKitMemberListTitle(
                      profile: profile,
                      onMoreAction: () async {
                        String? result = await showChatUIKitBottomSheet(
                          context: context,
                          items: [
                            ChatUIKitEventAction.normal(
                              label: '自定义事件1',
                              onTap: () {
                                Navigator.of(context).pop("自定义事件1");
                              },
                            ),
                            ChatUIKitEventAction.normal(
                              label: '自定义事件2',
                              onTap: () {
                                Navigator.of(context).pop("自定义事件2");
                              },
                            ),
                          ],
                        );
                        if (result != null) {
                          EasyLoading.showToast('点击了: $result');
                        }
                      },
                    );
                  },
                ),
                if (isOwner) ChatUIKitRoomMutesController('禁言列表')
              ]);
            },
            icon: Icon(
              Icons.group,
              color: theme.color.isDark ? Colors.white38 : Colors.white70,
            ),
          )),
          ChatUIKitAppBarAction(
            child: Switch(
              thumbIcon: WidgetStatePropertyAll(
                Icon(
                  ChatUIKitTheme.instance.color.isDark
                      ? Icons.bedtime
                      : Icons.sunny,
                  color: Colors.white,
                ),
              ),
              trackOutlineColor:
                  const WidgetStatePropertyAll(Colors.transparent),
              activeTrackColor: theme.color.neutralColor4,
              inactiveThumbColor: Colors.blue,
              activeColor: Colors.blue,
              value: !ChatUIKitTheme.instance.color.isDark,
              onChanged: (value) {
                setState(() {
                  ChatUIKitTheme.instance.setColor(
                    value ? ChatUIKitColor.light() : ChatUIKitColor.dark(),
                  );
                });
              },
            ),
          )
        ],
      ),
      body: content,
    );

    content = PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        ChatUIKit.instance.leaveChatRoom(roomId).then((_) {
          debugPrint('leave chat room');
        }).catchError((e) {
          debugPrint('leave chat room error: $e');
        });
      },
      child: content,
    );

    return content;
  }
}
