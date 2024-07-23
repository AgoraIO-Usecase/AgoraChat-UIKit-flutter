import '../../chat_uikit.dart';

class GroupMemberListViewController with ChatUIKitListViewControllerBase {
  GroupMemberListViewController({
    required this.groupId,
    this.willShowHandler,
    this.includeOwner = true,
    this.pageSize = 200,
  });
  final String groupId;
  final int pageSize;
  final bool includeOwner;
  String? cursor;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ContactListViewShowHandler? willShowHandler;

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
      List<ContactItemModel> tmp = mapperToContactItemModelItems(userIds);
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
      try {
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
      } catch (e) {
        hasMore = false;
      }
    } while (hasMore);
    return ret;
  }

  List<ContactItemModel> mapperToContactItemModelItems(List<String> userIds) {
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
