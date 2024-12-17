import '../../../chat_uikit.dart';
import '../../../universal/inner_headers.dart';
import 'package:flutter/material.dart';

class ChatUIKitMessageReactionInfo extends StatefulWidget {
  const ChatUIKitMessageReactionInfo(this.model, {super.key});

  final MessageModel model;
  @override
  State<ChatUIKitMessageReactionInfo> createState() =>
      _ChatUIKitMessageReactionInfoState();
}

class _ChatUIKitMessageReactionInfoState
    extends State<ChatUIKitMessageReactionInfo>
    with SingleTickerProviderStateMixin, ChatUIKitThemeMixin {
  late final TabController tabController;
  int selectIndex = 0;
  late List<MessageReaction> reactions;
  late String messageID;

  @override
  void initState() {
    super.initState();
    messageID = widget.model.message.msgId;
    reactions = widget.model.reactions!;
    tabController = TabController(
      length: widget.model.reactions!.length,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        selectIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 28,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reactions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    tabController.animateTo(index);
                  },
                  child: ChatUIkitReactionWidget(
                    reactions[index],
                    highlightColor: Colors.transparent,
                    highlightTextColor: theme.color.isDark
                        ? theme.color.neutralColor95
                        : theme.color.neutralColor3,
                    bgColor: selectIndex == index
                        ? (theme.color.isDark
                            ? theme.color.neutralColor3
                            : theme.color.neutralColor9)
                        : Colors.transparent,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: reactions
                .map(
                  (e) => ChatReactionInfoWidget(
                    msgId: messageID,
                    reaction: e,
                    onReactionDeleteTap: () {
                      onReactionDeleteTap(e);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void onReactionDeleteTap(MessageReaction reaction) {
    MessageReaction newReaction = reaction.copyWith(
      userCount: reaction.userCount - 1,
      isAddedBySelf: false,
    );
    int index = reactions
        .indexWhere((element) => reaction.reaction == element.reaction);
    reactions[index] = newReaction;
    setState(() {});
  }
}

class ChatReactionInfoWidget extends StatefulWidget {
  const ChatReactionInfoWidget({
    required this.msgId,
    required this.reaction,
    this.onReactionDeleteTap,
    super.key,
  });
  final String msgId;
  final MessageReaction reaction;
  final VoidCallback? onReactionDeleteTap;

  @override
  State<ChatReactionInfoWidget> createState() => _ChatReactionInfoWidgetState();
}

class _ChatReactionInfoWidgetState extends State<ChatReactionInfoWidget>
    with
        AutomaticKeepAliveClientMixin,
        ChatUIKitProviderObserver,
        ChatUIKitThemeMixin {
  List<ChatUIKitProfile> profiles = [];
  String? cursor;
  bool fetching = false;
  bool hasMore = false;
  bool firstLoadSucceed = false;
  int pageSize = 20;
  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    fetchReactionInfo();
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(
    Map<String, ChatUIKitProfile> map,
  ) {}

  void fetchReactionInfo() async {
    if (fetching) return;
    fetching = true;
    try {
      CursorResult<MessageReaction> result =
          await ChatUIKit.instance.fetchReactionDetail(
        messageId: widget.msgId,
        cursor: cursor,
        reaction: widget.reaction.reaction,
        pageSize: pageSize,
      );

      if (pageSize > result.data.length) {
        hasMore = false;
      }
      cursor = result.cursor;
      MessageReaction reaction = result.data.first;
      reaction.userList.remove(ChatUIKit.instance.currentUserId);
      Map<String, ChatUIKitProfile> map =
          ChatUIKitProvider.instance.getProfiles(
        reaction.userList.map((e) => ChatUIKitProfile.contact(id: e)).toList(),
      );

      for (var userId in reaction.userList) {
        profiles.add(map.values.firstWhere((element) => element.id == userId));
      }

      if (reaction.isAddedBySelf) {
        ChatUIKitProfile profile = ChatUIKitProvider.instance
                .getProfileById(ChatUIKit.instance.currentUserId!) ??
            ChatUIKitProfile.contact(id: ChatUIKit.instance.currentUserId!);

        profiles.insert(0, profile);
      }
      firstLoadSucceed = true;
      setState(() {});
    } catch (e) {
      chatPrint(e.toString());
    }
    fetching = false;
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    super.build(context);
    if (firstLoadSucceed == false) {
      return Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor7,
          ),
        ),
      );
    } else {
      return NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            if (notification.metrics.pixels ==
                notification.metrics.maxScrollExtent) {
              if (hasMore) {
                fetchReactionInfo();
              }
            }
          }
          return false;
        },
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return item(profiles[index], theme);
          },
          itemCount: profiles.length,
        ),
      );
    }
  }

  Widget item(ChatUIKitProfile profile, ChatUIKitTheme theme) {
    Widget content = ChatUIKitContactListViewItem(
      ContactItemModel.fromProfile(profile),
    );
    if (profile.id == ChatUIKit.instance.currentUserId) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: content),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              try {
                await ChatUIKit.instance.deleteReaction(
                  messageId: widget.msgId,
                  reaction: widget.reaction.reaction,
                );
                profiles.remove(profile);
                widget.onReactionDeleteTap?.call();
                setState(() {});
              } catch (e) {
                chatPrint(e.toString());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ChatUIKitImageLoader.voiceDelete(
                width: 28,
                height: 28,
                color: (theme.color.isDark
                    ? theme.color.neutralColor4
                    : theme.color.neutralColor7),
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }

  @override
  bool get wantKeepAlive => true;
}
