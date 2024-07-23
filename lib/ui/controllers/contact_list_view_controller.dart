import '../../chat_uikit.dart';

/// 联系人列表控制器
class ContactListViewController with ChatUIKitListViewControllerBase {
  ContactListViewController({
    this.willShowHandler,
    this.enableRefresh = true,
  });

  /// 是否开启下来刷新
  final bool enableRefresh;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ContactListViewShowHandler? willShowHandler;

  String? cursor;

  /// 获取联系人列表，会优先从本地获取，如果本地没有，并且没有从服务器获取过，则从服务器获取。
  /// `force` (bool) 是否强制从服务器获取，默认为 `false`。
  @override
  Future<void> fetchItemList({
    bool force = false,
    bool reload = false,
  }) async {
    if (reload) {
      loadingType.value = ChatUIKitListViewType.refresh;
    } else {
      loadingType.value = ChatUIKitListViewType.loading;
    }

    try {
      List<String> items = await ChatUIKit.instance.getAllContactIds();
      if ((items.isEmpty &&
              !ChatUIKitContext.instance.isContactLoadFinished()) ||
          force == true) {
        items = await fetchContacts();
      }
      ChatUIKitContext.instance.removeRequests(items);
      List<ContactItemModel> tmp = mapperToContactItemModels(items);
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

  Future<List<String>> fetchContacts() async {
    List<String> result = await ChatUIKit.instance.fetchAllContactIds();
    ChatUIKitContext.instance.setContactLoadFinished();
    return result;
  }

  List<ContactItemModel> mapperToContactItemModels(List<String> userIds) {
    List<ContactItemModel> list = [];
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
      list.add(info);
    }

    List<ContactItemModel>? contacts = willShowHandler?.call(list);
    if (contacts?.isNotEmpty == true) {
      list.clear();
      list.addAll(contacts!);
    }
    return list;
  }

  void addUser(String userId) {
    if (list
        .cast<ContactItemModel>()
        .any((element) => element.profile.id == userId)) {
      return;
    }
    List<ContactItemModel> tmp = mapperToContactItemModels([userId]);
    list.addAll(tmp);
  }

  /// 从新从本地获取联系人列表
  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<String> items = await ChatUIKit.instance.getAllContactIds();
    ChatUIKitContext.instance.removeRequests(items);
    List<ContactItemModel> tmp = mapperToContactItemModels(items);
    list.clear();
    list.addAll(tmp);

    loadingType.value = ChatUIKitListViewType.normal;
  }
}
