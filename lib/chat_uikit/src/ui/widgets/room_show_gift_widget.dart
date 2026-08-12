import 'dart:async';
import 'dart:math';

import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_service/chat_uikit_service.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/chat_uikit_extension.dart';
import 'package:agora_chat_uikit/chat_uikit/src/ui/models/room_uikit_gift_model.dart';
import 'package:agora_chat_uikit/chat_uikit_localizations/chat_uikit_localizations.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:agora_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

typedef ChatRoomShowGiftItemBuilder = Widget? Function(
  String senderId,
  ChatRoomGift gift,
  ChatUIKitProfile? user,
);

class ChatRoomShowGiftView extends StatefulWidget {
  const ChatRoomShowGiftView({
    required this.roomId,
    this.giftWidgetBuilder,
    this.giftPlaceHolderWidget,
    super.key,
  });

  final String roomId;
  final ChatRoomShowGiftItemBuilder? giftWidgetBuilder;
  final Widget? giftPlaceHolderWidget;

  @override
  State<ChatRoomShowGiftView> createState() => _ChatRoomShowGiftViewState();
}

const double totalHeight = 84;
const double originHeight = 44;
const double movedHeight = 36;

class _ChatRoomShowGiftViewState extends State<ChatRoomShowGiftView>
    with ChatObserver, MessageObserver, ChatUIKitThemeMixin {
  List<GiftReceiveModel> list = [];

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    for (var element in list) {
      element.stopTimer();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                height: totalHeight,
                color: Colors.transparent,
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return GiftReceiveItemWidget(
                key: ValueKey(list[index].randomKey),
                height: list.length - 1 == index ? originHeight : movedHeight,
                child: widget.giftWidgetBuilder?.call(
                      list[index].fromUserId,
                      list[index].gift,
                      list[index].userInfo,
                    ) ??
                    GiftItem(
                      list[index].gift,
                      list[index].fromUserId,
                      userInfo: list[index].userInfo,
                      placeHolder: widget.giftPlaceHolderWidget,
                    ),
              );
            },
            childCount: list.length,
            findChildIndexCallback: (key) {
              final index = list.indexWhere((element) {
                return element.randomKey == (key as ValueKey<String>).value;
              });
              return index > -1 ? index : null;
            },
          ),
        ),
      ],
    );

    content = SizedBox(
      height: totalHeight,
      child: content,
    );

    return content;
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    List<Message> localMsgs = List.from(messages);
    localMsgs.removeWhere((element) {
      return element.conversationId != widget.roomId ||
          element.isBroadcast ||
          !element.isChatRoomGift;
    });
    for (var msg in localMsgs) {
      showGift(msg);
    }
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    if (msg.conversationId != widget.roomId ||
        msg.isBroadcast ||
        !msg.isChatRoomGift) {
      return;
    }
    showGift(msg);
  }

  void showGift(Message msg) {
    ChatRoomGift? gift = msg.getGift();
    String senderId = msg.from!;
    ChatUIKitProfile? user = msg.getUserInfo();
    final model = GiftReceiveModel(
      gift!,
      senderId,
      userInfo: user,
      onTimeOut: (item) {
        final index = list.indexWhere((element) => element.isRunning);
        if (index == -1) {
          setState(() {
            list.clear();
          });
        }
      },
    );
    setState(() {
      list.add(model);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}

class GiftReceiveItemWidget extends StatefulWidget {
  const GiftReceiveItemWidget({
    required this.height,
    this.hiddenTime = 3,
    this.child,
    super.key,
  });

  final double height;
  final int hiddenTime;
  final Widget? child;

  @override
  State<GiftReceiveItemWidget> createState() => _GiftReceiveItemWidgetState();
}

class _GiftReceiveItemWidgetState extends State<GiftReceiveItemWidget> {
  bool isHidden = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isHidden ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: AnimatedScale(
        curve: Curves.decelerate,
        alignment: Alignment.bottomLeft,
        scale: widget.height / originHeight,
        duration: const Duration(milliseconds: 300),
        child: widget.child,
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: widget.hiddenTime), (timer) {
      stopTimer();
      setState(() {
        isHidden = true;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class GiftReceiveModel {
  GiftReceiveModel(
    this.gift,
    this.fromUserId, {
    this.userInfo,
    this.time = 5,
    this.onTimeOut,
  }) {
    startTimer();
  }
  final String randomKey = Random().nextInt(9999999).toString();
  final int time;

  final ChatRoomGift gift;
  final ChatUIKitProfile? userInfo;
  final String fromUserId;

  final void Function(GiftReceiveModel item)? onTimeOut;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(Duration(seconds: time), (timer) {
      stopTimer();
      isRunning = false;
      onTimeOut?.call(this);
    });
  }

  void stopTimer() {
    timer?.cancel();
  }
}

class GiftItem extends StatelessWidget {
  const GiftItem(
    this.gift,
    this.fromUserId, {
    this.count = 1,
    this.userInfo,
    this.placeHolder,
    super.key,
  });
  final String fromUserId;
  final ChatRoomGift gift;
  final int count;
  final Widget? placeHolder;
  final ChatUIKitProfile? userInfo;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: theme.color.barrageColor1),
        height: originHeight,
        child: item(context),
      ),
    );
  }

  Widget item(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    List<Widget> list = [];

    Widget content = ChatRoomUIKitAvatar(
      width: 36,
      height: 36,
      user: userInfo,
      margin: const EdgeInsets.all(4),
    );

    list.add(content);

    // 名字/礼物名称
    content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userInfo?.nickname ?? userInfo?.id ?? fromUserId,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: theme.font.labelSmall.fontWeight,
            fontSize: theme.font.labelSmall.fontSize,
            color: Colors.white,
          ),
        ),
        Text(
          gift.giftName ?? ChatUIKitLocal.roomGiftDefaultName.localString(context),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: theme.font.bodyExtraSmall.fontWeight,
            fontSize: theme.font.bodyExtraSmall.fontSize,
            color: Colors.white,
          ),
        ),
      ],
    );

    list.add(content);

    // 礼物图片
    list.add(ChatRoomImageLoader.roomNetworkImage(
      image: gift.giftIcon,
      size: 40,
      fit: BoxFit.fill,
      placeholderWidget: placeHolder ?? ChatRoomImageLoader.roomDefaultGift(),
    ));

    list.add(
      Padding(
        padding: const EdgeInsets.all(6),
        child: RichText(
          text: TextSpan(
            text: 'x',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            children: [
              TextSpan(
                text: gift.giftCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: item,
              ))
          .toList(),
    );

    content = Padding(
      padding: const EdgeInsets.only(right: 10),
      child: content,
    );

    return content;
  }
}
