import '../../chat_uikit.dart';

class GroupListViewController with ChatUIKitListViewControllerBase {
  GroupListViewController({
    this.pageSize = 20,
  });

  final int pageSize;
  int pageNum = 0;

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.loading;
    pageNum = 0;
    try {
      List<Group> items = await ChatUIKit.instance.fetchJoinedGroups(
        pageSize: pageSize,
        pageNum: pageNum,
      );
      List<GroupItemModel> tmp = mapperToGroupItemModelItems(items);
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
    List<GroupItemModel> tmp = mapperToGroupItemModelItems(items);
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

  List<GroupItemModel> mapperToGroupItemModelItems(List<Group> groups) {
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
