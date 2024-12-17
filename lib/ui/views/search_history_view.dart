import '../../chat_uikit.dart';
import '../../tools/chat_uikit_highlight_tool.dart';

import 'package:flutter/material.dart';

class SearchHistoryView extends StatefulWidget {
  SearchHistoryView.arguments(SearchHistoryViewArguments arguments, {super.key})
      : profile = arguments.profile,
        attributes = arguments.attributes,
        viewObserver = arguments.viewObserver;

  const SearchHistoryView({
    required this.profile,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final ChatUIKitProfile profile;

  final String? attributes;

  final ChatUIKitViewObserver? viewObserver;

  @override
  State<SearchHistoryView> createState() => _SearchHistoryViewState();
}

class _SearchHistoryViewState extends State<SearchHistoryView>
    with ChatUIKitThemeMixin {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  ValueNotifier<String> searchKeyword = ValueNotifier('');
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchKeyword.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      body: SafeArea(
        child: Column(
          children: [
            searchTextInputBar(),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: searchKeyword,
                builder: (context, keyword, child) {
                  if (keyword.isEmpty) {
                    return Center(
                      child: ChatUIKitImageLoader.listEmpty(),
                    );
                  }
                  return FutureBuilder(
                    future: ChatUIKit.instance.searchConversationLocalMessage(
                      conversationId: widget.profile.id,
                      type: widget.profile.type == ChatUIKitProfileType.group
                          ? ConversationType.GroupChat
                          : ConversationType.Chat,
                      keywords: keyword,
                      maxCount: 200,
                      direction: SearchDirection.Up,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.data?.isNotEmpty == true) {
                        messages = snapshot.data as List<Message>;
                        return ListView.builder(
                          itemBuilder: (ctx, index) {
                            return InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).pop(messages[index]);
                              },
                              child: ChatUIKitSearchHistoryViewItem(
                                message: messages[index],
                                highlightWord: keyword,
                              ),
                            );
                          },
                          itemCount: snapshot.data!.length,
                        );
                      } else {
                        return Center(
                          child: ChatUIKitImageLoader.listEmpty(),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchTextInputBar() {
    return SizedBox(
      height: 44,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 4, 0, 4),
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 7, 0, 7),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      CornerRadiusHelper.searchBarRadius(36)),
                  color: theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor95,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ChatUIKitImageLoader.search(
                      width: 22,
                      height: 22,
                      color: theme.color.neutralColor3,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        focusNode: searchFocusNode,
                        keyboardAppearance: theme.color.isDark
                            ? Brightness.dark
                            : Brightness.light,
                        autofocus: true,
                        style: TextStyle(
                            fontWeight: theme.font.bodyLarge.fontWeight,
                            fontSize: theme.font.bodyLarge.fontSize,
                            color: theme.color.isDark
                                ? theme.color.neutralColor98
                                : theme.color.neutralColor1),
                        controller: searchController,
                        scrollPadding: EdgeInsets.zero,
                        decoration: InputDecoration(
                          hintText:
                              ChatUIKitLocal.searchHistory.localString(context),
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintStyle: TextStyle(
                            color: theme.color.isDark
                                ? theme.color.neutralColor4
                                : theme.color.neutralColor6,
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: searchKeyword,
                      builder: (context, value, child) {
                        if (value.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                searchController.clear();
                              },
                              child: Icon(
                                Icons.cancel,
                                size: 22,
                                color: theme.color.isDark
                                    ? theme.color.neutralColor7
                                    : theme.color.neutralColor3,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                searchController.clear();
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  ChatUIKitLocal.searchWidgetCancel.localString(context),
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5,
                    fontWeight: theme.font.bodyLarge.fontWeight,
                    fontSize: theme.font.bodyLarge.fontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatUIKitSearchHistoryViewItem extends StatelessWidget {
  final Message message;
  final String? highlightWord;

  const ChatUIKitSearchHistoryViewItem({
    required this.message,
    this.highlightWord,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ChatUIKitProfile? profile =
        ChatUIKitProvider.instance.getProfileById(message.from!);
    final theme = ChatUIKitTheme.instance;
    Widget title = Text(
      profile?.contactShowName ?? message.nickname ?? message.from!,
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
      style: theme.titleMedium(
          color: theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1),
    );

    Widget subtitle = HighlightTool.highlightWidget(
      context,
      message.showInfo(),
      searchKey: highlightWord,
      textStyle: theme.titleMedium(
          color: theme.color.isDark
              ? theme.color.neutralColor6
              : theme.color.neutralColor5),
      highlightStyle: theme.titleMedium(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
      ),
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        Flexible(fit: FlexFit.loose, child: subtitle),
      ],
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: profile?.avatarUrl ?? message.fromProfile.avatarUrl,
      size: 40,
    );

    content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        const SizedBox(width: 12),
        Expanded(child: content),
      ],
    );
    content = Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      height: 60 - 0.5,
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 68,
          right: 0,
          height: 0.5,
          child: Divider(
            height: borderHeight,
            thickness: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          ),
        )
      ],
    );
    return content;
  }
}
