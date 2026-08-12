import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_settings.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/chat_uikit_extension.dart';
import 'package:agora_chat_uikit/chat_uikit/src/ui/custom/custom_tab_indicator.dart';
import 'package:agora_chat_uikit/chat_uikit/src/ui/models/room_uikit_gift_model.dart';
import 'package:agora_chat_uikit/chat_uikit_localizations/chat_uikit_localizations.dart';
import 'package:agora_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

/// Gift page controller, you can customize the gift page
class ChatroomGiftPageController {
  /// gift page title
  final String title;
  final List<ChatRoomGift> gifts;

  ChatroomGiftPageController({
    required this.title,
    required this.gifts,
  });
}

class ChatRoomGiftsView extends StatefulWidget {
  const ChatRoomGiftsView({
    required this.giftControllers,
    this.onSendTap,
    super.key,
  });

  final List<ChatroomGiftPageController> giftControllers;
  final void Function(ChatRoomGift gift)? onSendTap;

  @override
  State<ChatRoomGiftsView> createState() => _ChatRoomGiftsViewState();
}

class _ChatRoomGiftsViewState extends State<ChatRoomGiftsView>
    with SingleTickerProviderStateMixin, ChatUIKitThemeMixin {
  late TabController _tabController;

  @override
  void initState() {
    assert(
        widget.giftControllers.isNotEmpty, "giftControllers cannot be empty");
    super.initState();
    _tabController =
        TabController(vsync: this, length: widget.giftControllers.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return ChatBottomSheetBackground(
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            indicator: CustomTabIndicator(
              radius: 2,
              color: theme.color.isDark
                  ? theme.color.primaryColor6
                  : theme.color.primaryColor5,
              size: const Size(28, 4),
            ),
            controller: _tabController,
            labelStyle: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
            ),
            labelColor: (theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1),
            tabs:
                widget.giftControllers.map((e) => Tab(text: e.title)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.giftControllers
                  .map(
                    (e) => ChatRoomGiftsWidget(
                      giftEntities: e.gifts,
                      onSendTap: (gift) {
                        widget.onSendTap?.call(gift);
                      },
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class ChatRoomGiftsWidget extends StatefulWidget {
  const ChatRoomGiftsWidget({
    required this.giftEntities,
    this.placeholder,
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 14.0,
    this.crossAxisSpacing = 14.0,
    this.childAspectRatio = 80.0 / 98.0,
    this.onSendTap,
    super.key,
  });

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final String? placeholder;

  final void Function(ChatRoomGift gift)? onSendTap;

  final List<ChatRoomGift> giftEntities;

  @override
  State<ChatRoomGiftsWidget> createState() => _ChatRoomGiftsWidgetState();
}

class _ChatRoomGiftsWidgetState extends State<ChatRoomGiftsWidget>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.custom(
      padding: const EdgeInsets.only(left: 14, top: 4, right: 14, bottom: 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      childrenDelegate: SliverChildBuilderDelegate((context, position) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == position ? -1 : position;
            });
          },
          child: ChatRoomGiftItem(
            placeholder: widget.placeholder,
            selected: selectedIndex == position,
            gift: widget.giftEntities[position],
            onSendTap: widget.onSendTap,
          ),
        );
      }, childCount: widget.giftEntities.length),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatRoomGiftItem extends StatelessWidget {
  const ChatRoomGiftItem({
    required this.gift,
    this.placeholder,
    this.onSendTap,
    this.selected = false,
    super.key,
  });

  final String? placeholder;
  final ChatRoomGift gift;
  final void Function(ChatRoomGift entity)? onSendTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;

    Widget placeholderWidget = (placeholder != null)
        ? Image.asset(placeholder!, fit: BoxFit.fill)
        : (ChatUIKitSettings.roomDefaultGiftIcon == null)
            ? Container()
            : Image.asset(
                ChatUIKitSettings.roomDefaultGiftIcon!,
              );

    Widget imageWidget = ChatRoomImageLoader.roomNetworkImage(
      image: gift.giftIcon,
      placeholderWidget: placeholderWidget,
      fit: BoxFit.fill,
    );

    imageWidget = Container(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 2), child: imageWidget);

    List<Widget> widgets = [];
    widgets.add(
      Expanded(child: imageWidget),
    );

    if (selected) {
      widgets.addAll([
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            () {
              if (ChatUIKitSettings.roomDefaultGiftPriceIcon != null) {
                return Image.asset(
                  ChatUIKitSettings.roomDefaultGiftPriceIcon!,
                  width: 14,
                  height: 14,
                );
              } else {
                return const SizedBox();
              }
            }(),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                gift.giftPrice.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: theme.font.labelExtraSmall.fontWeight,
                  fontSize: theme.font.labelExtraSmall.fontSize,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor6
                      : theme.color.neutralColor5),
                ),
              ),
            )
          ],
        ),
        InkWell(
          onTap: () => onSendTap?.call(gift),
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: (theme.color.isDark
                  ? theme.color.primaryColor5
                  : theme.color.primaryColor6),
            ),
            child: Center(
              child: Text(
                ChatUIKitLocal.roomGiftSend.localString(context),
                style: TextStyle(
                  fontWeight: theme.font.labelMedium.fontWeight,
                  fontSize: theme.font.labelMedium.fontSize,
                  color: theme.color.neutralColor98,
                ),
              ),
            ),
          ),
        ),
      ]);
    } else {
      widgets.addAll([
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Text(
            gift.giftName!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontWeight: theme.font.titleSmall.fontWeight,
              fontSize: theme.font.titleSmall.fontSize,
              color: (theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1),
            ),
          ),
        ),
        SizedBox(
          height: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              () {
                if (ChatUIKitSettings.roomDefaultGiftPriceIcon != null) {
                  return Image.asset(
                    ChatUIKitSettings.roomDefaultGiftPriceIcon!,
                    width: 14,
                    height: 14,
                  );
                } else {
                  return const SizedBox();
                }
              }(),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  gift.giftPrice.toString(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: theme.font.labelExtraSmall.fontWeight,
                    fontSize: theme.font.labelExtraSmall.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5),
                  ),
                ),
              )
            ],
          ),
        ),
      ]);
    }

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );

    content = Container(
      clipBehavior: selected ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? (theme.color.isDark
                  ? theme.color.primaryColor5
                  : theme.color.primaryColor6)
              : Colors.transparent,
        ),
      ),
      child: content,
    );

    return content;
  }
}
