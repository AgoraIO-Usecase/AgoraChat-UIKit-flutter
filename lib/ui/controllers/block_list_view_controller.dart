import '../../chat_uikit.dart';

class BlockListViewController
    with ChatUIKitListViewControllerBase, ContactObserver {
  BlockListViewController({
    this.willShowHandler,
    this.enableRefresh = true,
  }) {
    ChatUIKit.instance.addObserver(this);
  }

  /// 是否开启下来刷新
  final bool enableRefresh;

  /// 会话列表显示前的回调，你可以在这里对会话列表进行处理，比如排序或者加减等。如果不设置将会直接显示。
  final ContactListViewShowHandler? willShowHandler;

  bool hasFetched = false;

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onBlockedContactAdded(String userId) {
    if (list
        .any((element) => (element as ContactItemModel).profile.id == userId)) {
      return;
    }
    List<ContactItemModel> tmp = mapperToContactItemModelItems([userId]);
    list.addAll(tmp);
    refresh();
  }

  @override
  void onBlockedContactDeleted(String userId) {
    if (list
        .any((element) => (element as ContactItemModel).profile.id == userId)) {
      list.removeWhere(
          (element) => (element as ContactItemModel).profile.id == userId);
      refresh();
    }
  }

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

    List<String>? items;

    try {
      if (force == true || hasFetched == false) {
        items = await fetchBlocks();
        hasFetched = true;
      } else {
        items = await ChatUIKit.instance.getAllBlockedContactIds();
      }

      List<ContactItemModel> tmp = mapperToContactItemModelItems(items);
      list.clear();
      list.addAll(tmp);
      if (list.isEmpty) {
        loadingType.value = ChatUIKitListViewType.empty;
      } else {
        loadingType.value = ChatUIKitListViewType.normal;
      }
    } catch (e) {
      items ??= await ChatUIKit.instance.getAllBlockedContactIds();
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  Future<List<String>> fetchBlocks() async {
    List<String> result = await ChatUIKit.instance.fetchAllBlockedContactIds();
    ChatUIKitContext.instance.setContactLoadFinished();
    return result;
  }

  List<ContactItemModel> mapperToContactItemModelItems(List<String> userIds) {
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
    List<ContactItemModel> tmp = mapperToContactItemModelItems([userId]);
    list.addAll(tmp);
  }

  /// 从新从本地获取联系人列表
  @override
  Future<void> reload() async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List<String> items = await ChatUIKit.instance.getAllBlockedContactIds();
    ChatUIKitContext.instance.removeRequests(items);
    List<ContactItemModel> tmp = mapperToContactItemModelItems(items);
    list.clear();
    list.addAll(tmp);

    loadingType.value = ChatUIKitListViewType.normal;
  }
}
