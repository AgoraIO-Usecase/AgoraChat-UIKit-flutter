import '../../chat_uikit.dart';

class GroupMemberListViewController
    with ChatUIKitListViewControllerBase, ChatUIKitProviderObserver {
  GroupMemberListViewController({
    required this.groupId,
    this.willShowHandler,
    this.includeOwner = true,
    this.pageSize = 200,
  }) {
    ChatUIKitProvider.instance.addObserver(this);
  }
  final String groupId;
  final int pageSize;
  final bool includeOwner;
  String? cursor;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ContactListViewShowHandler? willShowHandler;

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (list.any((element) =>
        map.keys.contains((element as ContactItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = list
            .indexWhere((e) => (e as ContactItemModel).profile.id == element);
        if (index != -1) {
          list[index] = (list[index] as ContactItemModel)
              .copyWith(profile: map[element]!);
        }
      }
      refresh();
    }
  }

  @override
  Future<void> fetchItemList({bool force = false}) async {
    try {
      loadingType.value = ChatUIKitListViewType.loading;
      cursor = null;
      List<String> ret = await fetchAllMembers();

      List<String> userIds = ret;
      if (includeOwner) {
        Group? group = await ChatUIKit.instance.getGroup(groupId: groupId);
        if (group?.owner?.isNotEmpty == true) {
          userIds.insert(0, group!.owner!);
        }
      }
      List<ContactItemModel> tmp = mappers(userIds);
      list.clear();
      list.addAll(tmp);

      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      loadingType.value = ChatUIKitListViewType.error;
    }
  }

  Future<List<String>> fetchAllMembers() async {
    List<String> ret = [];
    do {
      CursorResult<String> items =
          await ChatUIKit.instance.fetchGroupMemberList(
        groupId: groupId,
        pageSize: pageSize,
        cursor: cursor,
      );

      cursor = items.cursor;
      ret.addAll(items.data);
      if (items.data.length < pageSize) {
        hasMore = false;
      }
    } while (hasMore);

    return ret;
  }

  @override
  Future<void> fetchMoreItemList() async {
    if (hasMore) {
      try {
        loadingType.value = ChatUIKitListViewType.refresh;
        CursorResult<String> items =
            await ChatUIKit.instance.fetchGroupMemberList(
          groupId: groupId,
          pageSize: pageSize,
          cursor: cursor,
        );
        cursor = items.cursor;
        if (items.data.length < pageSize) {
          hasMore = false;
        }
        List<ContactItemModel> tmp = mappers(items.data);
        list.addAll(tmp);
        loadingType.value = ChatUIKitListViewType.normal;
        // ignore: empty_catches
      } catch (e) {}
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  List<ContactItemModel> mappers(List<String> userIds) {
    List<ContactItemModel> models = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> profile = [];
      for (var item in userIds) {
        profile.add(ChatUIKitProfile.contact(id: item));
      }
      return profile;
    }());
    for (var item in userIds) {
      ContactItemModel info = ContactItemModel.fromProfile(map[item]!);
      models.add(info);
    }

    List<ContactItemModel>? contacts = willShowHandler?.call(models);
    if (contacts?.isNotEmpty == true) {
      models.clear();
      models.addAll(contacts!);
    }

    return models;
  }
}
