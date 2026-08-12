import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_service/chat_uikit_service.dart';
import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_settings.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/chat_uikit_extension.dart';
import 'package:agora_chat_uikit/chat_uikit/src/ui/custom/custom_tab_indicator.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:agora_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit_localizations/chat_uikit_localizations.dart';

import 'package:flutter/material.dart';

class ChatUIKitRoomMutesController extends ChatUIKitRoomMembersInterface {
  ChatUIKitRoomMutesController(super.title, {super.itemBuilder});
  String? cursor;
  int pageNumber = 1;

  @override
  Future<List<String>> loadData() async {
    if (isLoadFinished) return [];
    try {
      List<String> result = await ChatUIKit.instance.fetchChatRoomMuteList(
        roomId: _state!.roomId,
        pageNum: pageNumber,
      );

      pageNumber++;
      firstLoading.value = false;
      if (result.length < pageNumber) {
        isLoadFinished = true;
      }

      if (lastMember?.isNotEmpty == true && lastMember == result.last) {
        result = [];
        isLoadFinished = true;
      } else {
        lastMember = result.last;
      }

      return result;
    } catch (e) {
      firstLoading.value = false;
      debugPrint('Error fetching chat room members: $e');
      return [];
    }
  }

  @override
  Future<List<String>> reloadData() async {
    try {
      pageNumber = 1;
      lastMember = null;
      List<String> result = await ChatUIKit.instance.fetchChatRoomMuteList(
        roomId: _state!.roomId,
        pageNum: pageNumber,
      );
      pageNumber;
      firstLoading.value = false;
      return result;
    } catch (e) {
      firstLoading.value = false;
      debugPrint('Error fetching chat room members: $e');
      return [];
    }
  }
}

class ChatUIKitRoomMembersController extends ChatUIKitRoomMembersInterface {
  ChatUIKitRoomMembersController(super.title, {super.itemBuilder});
  String? cursor;
  final int pageSize = 10;

  @override
  Future<List<String>> loadData() async {
    try {
      if (cursor == '') {
        return [];
      }
      CursorResult<String> result =
          await ChatUIKit.instance.fetchChatRoomMembers(
        roomId: _state!.roomId,
        cursor: cursor,
        pageSize: pageSize,
      );
      cursor = result.cursor ?? '';
      debugPrint("tttt ${result.data}");
      return result.data;
    } catch (e) {
      debugPrint('Error fetching chat room members: $e');
      return [];
    }
  }

  @override
  Future<List<String>> reloadData() async {
    try {
      cursor = null;
      CursorResult<String> result =
          await ChatUIKit.instance.fetchChatRoomMembers(
        roomId: _state!.roomId,
        cursor: cursor,
      );
      cursor = result.cursor;
      firstLoading.value = false;
      return result.data;
    } catch (e) {
      debugPrint('Error fetching chat room members: $e');
      return [];
    }
  }
}

typedef ChatRoomUIKitMembersListItemBuilder = Widget? Function(
  BuildContext context,
  ChatUIKitProfile profile,
  VoidCallback? onMoreAction,
);

abstract class ChatUIKitRoomMembersInterface {
  ChatUIKitRoomMembersInterface(this.title, {this.itemBuilder});
  final String title;
  final ChatRoomUIKitMembersListItemBuilder? itemBuilder;
  ValueNotifier firstLoading = ValueNotifier(true);
  bool isLoadFinished = false;
  String? lastMember;

  _ChatRoomMembersWidgetState? _state;
  void _attach(_ChatRoomMembersWidgetState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  Future<List<String>> loadData();

  Future<List<String>> reloadData();
}

class ChatUIKitRoomMembersWidget extends StatefulWidget {
  const ChatUIKitRoomMembersWidget({
    required this.roomId,
    required this.ownerId,
    required this.controllers,
    this.showIdentify = true,
    super.key,
  });
  final String roomId;
  final String ownerId;
  final bool showIdentify;
  final List<ChatUIKitRoomMembersInterface> controllers;

  @override
  State<ChatUIKitRoomMembersWidget> createState() =>
      _ChatUIKitRoomMembersWidgetState();
}

class _ChatUIKitRoomMembersWidgetState extends State<ChatUIKitRoomMembersWidget>
    with SingleTickerProviderStateMixin, ChatUIKitThemeMixin {
  late List<ChatUIKitRoomMembersInterface> controllers;
  late TabController _tabController;

  ScrollController scrollController = ScrollController();

  ValueNotifier onSearch = ValueNotifier(false);

  String get roomId => widget.roomId;
  @override
  void initState() {
    super.initState();

    controllers = widget.controllers;
    _tabController = TabController(
      vsync: this,
      length: widget.controllers.length,
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = ValueListenableBuilder(
        valueListenable: onSearch,
        builder: (context, value, child) {
          Widget content = ChatBottomSheetBackground(
            showGrip: !value,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: value ? 0 : 44,
                  child: TabBar(
                    tabAlignment: TabAlignment.center,
                    dividerColor: Colors.transparent,
                    indicator: CustomTabIndicator(
                      radius: 2,
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      size: value ? Size.zero : const Size(28, 4),
                    ),
                    controller: _tabController,
                    labelStyle: TextStyle(
                      fontWeight: theme.font.titleMedium.fontWeight,
                      fontSize: theme.font.titleMedium.fontSize,
                    ),
                    labelColor: (theme.color.isDark
                        ? theme.color.neutralColor98
                        : theme.color.neutralColor1),
                    isScrollable: true,
                    tabs: widget.controllers
                        .map((controller) => Tab(text: controller.title))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: widget.controllers.map((controller) {
                      return ChatRoomMembersWidget(
                        roomId: roomId,
                        controller: controller,
                        ownerId: widget.ownerId,
                        showIdentify: widget.showIdentify,
                        onSearch: (isSearch) {
                          onSearch.value = isSearch;
                        },
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          );

          content = AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: value
                ? MediaQuery.of(context).size.height - 54
                : MediaQuery.of(context).size.height * 3 / 5,
            child: content,
          );
          return content;
        });

    return content;
  }
}

class ChatRoomMembersWidget extends StatefulWidget {
  const ChatRoomMembersWidget({
    required this.roomId,
    required this.controller,
    this.ownerId,
    this.onSearch,
    this.showIdentify = true,
    super.key,
  });
  final String roomId;
  final String? ownerId;
  final void Function(bool onSearch)? onSearch;
  final ChatUIKitRoomMembersInterface controller;
  final bool showIdentify;

  @override
  State<ChatRoomMembersWidget> createState() => _ChatRoomMembersWidgetState();
}

class _ChatRoomMembersWidgetState extends State<ChatRoomMembersWidget>
    with AutomaticKeepAliveClientMixin {
  List<ChatUIKitProfile> members = [];
  ScrollController scrollController = ScrollController();
  ValueNotifier isSearch = ValueNotifier(false);
  String get roomId => widget.roomId;
  bool loadingMore = false;
  FocusNode focusNode = FocusNode();
  String keyword = '';
  List<ChatUIKitProfile> showUsers = [];

  bool isOwner = false;
  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
    isOwner = widget.ownerId == ChatUIKit.instance.currentUserId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = ScrollController()
        ..addListener(() async {
          if (isSearch.value) return;
          if (scrollController.position.maxScrollExtent <
              scrollController.position.pixels + 40) {
            if (loadingMore) {
              return;
            }
            loadingMore = true;
            await loadData();
            loadingMore = false;
          }
        });

      loadData();
    });
  }

  @override
  void dispose() {
    widget.controller._detach();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    List<String> list = await widget.controller.loadData();
    List<ChatUIKitProfile> temp =
        list.map((userId) => ChatUIKitProfile.contact(id: userId)).toList();
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(temp, belongId: widget.roomId);
    members.removeWhere((element) => map.values.contains(element.id));
    members.addAll(map.values);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> reloadData() async {
    List<String> list = await widget.controller.reloadData();
    List<ChatUIKitProfile> temp =
        list.map((userId) => ChatUIKitProfile.contact(id: userId)).toList();
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(temp, belongId: widget.roomId);
    members.removeWhere((element) => map.values.contains(element.id));
    members.addAll(map.values);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = ChatUIKitTheme.instance;
    Widget content = ListView.separated(
      itemBuilder: (context, index) {
        ChatUIKitProfile profile = members[index];
        showUsers.add(profile);
        return widget.controller.itemBuilder?.call(context, profile, null) ??
            ChatRoomUIKitMemberListTitle(
              profile: profile,
              onMoreAction: isOwner && profile.id != widget.ownerId
                  ? () {
                      Navigator.of(context).pop();
                    }
                  : null,
            );
      },
      controller: scrollController,
      separatorBuilder: (context, index) => Divider(
        indent: 68,
        color: (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor9),
      ),
      cacheExtent: 100,
      itemCount: members.length,
    );

    if (!isSearch.value) {
      content = RefreshIndicator(
        onRefresh: () async {
          await reloadData();
        },
        child: content,
      );
    }

    content = Column(
      children: [
        searchBar(),
        () {
          if (isSearch.value != true || keyword.isNotEmpty) {
            if (members.isEmpty) {
              return Align(
                heightFactor: 1.5,
                child: ChatRoomImageLoader.roomEmpty(),
              );
            } else {
              return Expanded(child: content);
            }
          } else {
            return Container();
          }
        }(),
      ],
    );

    content = PopScope(
      child: content,
      onPopInvokedWithResult: (didPop, _) async {
        focusNode.unfocus();
      },
    );

    return content;
  }

  Widget firstLoadingWidget() {
    return const SizedBox(
      height: 30,
      width: 30,
      child: Center(
        child: SafeArea(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    // TODO: 搜索
    return const SizedBox();
    Widget content;
    final theme = ChatUIKitTheme.instance;
    content = ValueListenableBuilder(
      valueListenable: isSearch,
      builder: (context, value, child) {
        Widget content;
        if (value) {
          content = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: (theme.color.isDark
                        ? theme.color.neutralColor2
                        : theme.color.neutralColor95),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 6, 4, 8),
                        child: ChatRoomImageLoader.roomSearch(
                          size: 20,
                          color: (theme.color.isDark
                              ? theme.color.neutralColor4
                              : theme.color.neutralColor6),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              color: theme.color.isDark
                                  ? theme.color.neutralColor98
                                  : theme.color.neutralColor1,
                              fontWeight: theme.font.bodyLarge.fontWeight,
                              fontSize: theme.font.bodyLarge.fontSize),
                          keyboardAppearance: theme.color.isDark
                              ? Brightness.dark
                              : Brightness.light,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: -8,
                            ),
                            hintText: ChatUIKitLocal.roomMembersSearch.localString(context),
                            hintStyle: TextStyle(
                              fontWeight: theme.font.bodyLarge.fontWeight,
                              fontSize: theme.font.bodyLarge.fontSize,
                              color: (theme.color.isDark
                                  ? theme.color.neutralColor4
                                  : theme.color.neutralColor6),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              keyword = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(19, 4, 20, 4),
                child: InkWell(
                  onTap: () {
                    keyword = '';
                    showUsers.clear();
                    isSearch.value = false;
                    widget.onSearch?.call(false);
                    focusNode.unfocus();
                  },
                  child: Text(
                    ChatUIKitLocal.roomMembersCancel.localString(context),
                    style: TextStyle(
                      color: (theme.color.isDark
                          ? theme.color.neutralColor6
                          : theme.color.primaryColor5),
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          content = Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor95),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChatRoomImageLoader.roomSearch(
                  size: 22,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor4
                      : theme.color.neutralColor6),
                ),
                const SizedBox(width: 5.83),
                Text(
                  ChatUIKitLocal.roomMembersSearch.localString(context),
                  style: TextStyle(
                    fontWeight: theme.font.bodyLarge.fontWeight,
                    fontSize: theme.font.bodyLarge.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor6),
                  ),
                ),
              ],
            ),
          );

          content = InkWell(
            onTap: () {
              isSearch.value = true;
              widget.onSearch?.call(true);
              focusNode.requestFocus();
            },
            child: content,
          );
        }

        return content;
      },
    );

    return content;
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatRoomUIKitMemberListTitle extends StatefulWidget {
  const ChatRoomUIKitMemberListTitle({
    required this.profile,
    this.onMoreAction,
    this.showIdentify = true,
    super.key,
  });

  final ChatUIKitProfile profile;
  final VoidCallback? onMoreAction;
  final bool showIdentify;
  @override
  State<ChatRoomUIKitMemberListTitle> createState() =>
      _ChatRoomUIKitMemberListTitleState();
}

class _ChatRoomUIKitMemberListTitleState
    extends State<ChatRoomUIKitMemberListTitle> with ChatUIKitThemeMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        () {
          if (widget.profile.identify?.isNotEmpty == true &&
              widget.showIdentify) {
            return Container(
              margin: const EdgeInsets.only(right: 14.7),
              width: 21.67,
              height: 21.76,
              child: ChatRoomImageLoader.roomNetworkImage(
                image: widget.profile.identify,
                placeholderWidget:
                    (ChatUIKitSettings.roomDefaultIdentify == null)
                        ? Container()
                        : Image.asset(ChatUIKitSettings.roomDefaultIdentify!),
              ),
            );
          } else {
            return Container();
          }
        }(),
        ChatRoomUIKitAvatar(
          width: 40,
          height: 40,
          user: widget.profile,
        ),
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.profile.nickname,
                style: TextStyle(
                  fontWeight: theme.font.titleMedium.fontWeight,
                  fontSize: theme.font.titleMedium.fontSize,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        if (widget.onMoreAction != null)
          () {
            return InkWell(
              onTap: () {
                widget.onMoreAction?.call();
              },
              child: Icon(
                Icons.more_vert,
                color: (theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor6),
              ),
            );
          }()
      ],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      height: 60,
      color: (theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98),
      child: content,
    );
  }
}
