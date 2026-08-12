import 'dart:async';
import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_service/chat_uikit_service.dart';
import 'package:flutter/material.dart';

class ChatRoomGlobalMessageWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomGlobalMessageWidget({
    this.icon,
    this.textStyle,
    this.backgroundColor,
    super.key,
  });
  final Widget? icon;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  @override
  State<ChatRoomGlobalMessageWidget> createState() =>
      _ChatRoomGlobalMessageWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(20);
}

class _ChatRoomGlobalMessageWidgetState
    extends State<ChatRoomGlobalMessageWidget>
    with ChatObserver, ChatUIKitThemeMixin {
  ScrollController scrollController = ScrollController();

  double maxSize = 0;
  List<String> showList = [];
  String? current;
  Timer? timer;
  bool isPlaying = false;
  bool needScroll = false;

  StreamSubscription<dynamic>? _sub;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    scrollController.dispose();
    timer?.cancel();
    _sub?.cancel();
    current = null;
    isPlaying = false;
    super.dispose();
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    List<String> contents = [];
    List<Message> localMsgs = List.from(messages);
    localMsgs.removeWhere((element) => !element.isBroadcast);
    for (final msg in localMsgs) {
      if (msg.body.type == MessageType.TXT) {
        contents.add((msg.body as TextMessageBody).content);
      }
    }
    if (contents.isNotEmpty) {
      showList.addAll(contents);
      play();
    }
  }

  void play() {
    if (showList.isEmpty || isPlaying) return;
    isPlaying = true;
    current = showList.removeAt(0);
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: current,
        style: widget.textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final length = maxSize - (widget.icon != null ? 38 : 19);

    needScroll = painter.size.width > length;

    if (needScroll) {
      _showMarquee();
    } else {
      _showLabel();
    }
  }

  void _showMarquee() async {
    update();
    await Future.delayed(const Duration(seconds: 2));
    if (scrollController.positions.isEmpty) {
      return;
    }

    double maxScrollExtent = scrollController.position.maxScrollExtent;
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (scrollController.positions.isEmpty) {
        timer.cancel();
        return;
      }

      double pixels = scrollController.position.pixels;
      double nextPosition = pixels + 10;
      if (nextPosition > maxScrollExtent) {
        scrollController.animateTo(maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);

        timer.cancel();
        _sub = Future.delayed(const Duration(seconds: 2))
            .then((value) {
              clear();
              return Future.delayed(const Duration(milliseconds: 500));
            })
            .then((value) {
              play();
            })
            .asStream()
            .listen(
              (event) {},
            );
        return;
      }

      scrollController.animateTo(nextPosition,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  void _showLabel() async {
    update();
    _sub = Future.delayed(const Duration(seconds: 2))
        .then((value) {
          clear();
          return Future.delayed(const Duration(milliseconds: 500));
        })
        .then((value) {
          play();
        })
        .asStream()
        .listen(
          (event) {},
        );
  }

  void clear() {
    if (scrollController.positions.isNotEmpty) {
      scrollController.jumpTo(0);
    }

    current = null;
    isPlaying = false;
    update();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content;
    if (!isPlaying) {
      content = Container();
    } else {
      content = Text(
        current ?? '',
        style: widget.textStyle ??
            TextStyle(
              height: 1.6,
              fontSize: theme.font.bodySmall.fontSize,
              fontWeight: theme.font.bodySmall.fontWeight,
              color: Colors.white,
            ),
      );

      if (needScroll) {
        content = ListView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          children: [content],
        );
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          () {
            if (widget.icon != null) {
              return Container(
                padding: const EdgeInsets.only(left: 5, top: 0, bottom: 1),
                height: 20,
                decoration: BoxDecoration(
                  color: (widget.backgroundColor ??
                      (theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5)),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: widget.icon!,
                ),
              );
            }
            return Container();
          }(),
          () {
            Widget ret = Container(
              padding: EdgeInsets.only(
                  left: widget.icon == null ? 9 : 3,
                  right: 10,
                  top: 0,
                  bottom: 1),
              height: 20,
              decoration: BoxDecoration(
                color: (widget.backgroundColor ??
                    (theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5)),
                borderRadius: BorderRadius.only(
                  topLeft: widget.icon == null
                      ? const Radius.circular(10)
                      : Radius.zero,
                  bottomLeft: widget.icon == null
                      ? const Radius.circular(10)
                      : Radius.zero,
                  topRight: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: content,
            );

            if (needScroll) {
              ret = Expanded(
                child: ret,
              );
            }
            return ret;
          }(),
        ],
      );
    }

    content = PopScope(
      child: content,
      onPopInvokedWithResult: (didPop, _) async {
        showList.clear();
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        maxSize = constraints.maxWidth;
        return content;
      },
    );
  }
}
