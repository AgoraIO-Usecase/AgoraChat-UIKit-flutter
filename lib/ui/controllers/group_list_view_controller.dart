import '../../chat_uikit.dart';

class GroupListViewController
    with ChatUIKitListViewControllerBase, ChatUIKitProviderObserver {
  GroupListViewController({
    this.pageSize = 20,
  }) {
    ChatUIKitProvider.instance.addObserver(this);
  }

  final int pageSize;
  int pageNum = 0;

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (list.any((element) =>
        map.keys.contains((element as GroupItemModel).profile.id))) {
      for (var element in map.keys) {
        int index =
            list.indexWhere((e) => (e as GroupItemModel).profile.id == element);
        if (index != -1) {
          list[index] =
              (list[index] as GroupItemModel).copyWith(profile: map[element]!);
        }
      }
      refresh();
    }
  }

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    pageNum = 0;
    try {
      List<Group> items = await ChatUIKit.instance.fetchJoinedGroups(
        pageSize: pageSize,
        pageNum: pageNum,
      );
      List<GroupItemModel> tmp = mappers(items);
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

  @override
  Future<void> fetchMoreItemList() async {
    if (!hasMore) return;
    pageNum += 1;
    List<Group> items = await ChatUIKit.instance.fetchJoinedGroups(
      pageSize: pageSize,
      pageNum: pageNum,
    );
    if (items.isEmpty || items.length < pageSize) {
      hasMore = false;
    }
    List<GroupItemModel> tmp = mappers(items);
    list.addAll(tmp);
    refresh();
  }

  void addNewGroup(String groupId) async {
    Group? group = await ChatUIKit.instance.getGroup(groupId: groupId);
    if (group == null) return;
    GroupItemModel info = GroupItemModel.fromProfile(
      ChatUIKitProfile.group(
        id: group.groupId,
        groupName: group.name,
      ),
    );
    list.insert(0, info);
    refresh();
  }

  List<GroupItemModel> mappers(List<Group> groups) {
    List<GroupItemModel> list = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> list = [];
      for (var item in groups) {
        list.add(ChatUIKitProfile.group(
          id: item.groupId,
          groupName: item.name,
        ));
      }
      return list;
    }());
    for (var item in map.entries) {
      GroupItemModel info = GroupItemModel.fromProfile(item.value);
      list.add(info);
    }
    return list;
  }
}
