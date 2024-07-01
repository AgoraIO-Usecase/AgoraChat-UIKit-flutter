import '../../chat_uikit.dart';

class NewRequestListViewController
    with ChatUIKitListViewControllerBase, ChatUIKitProviderObserver {
  NewRequestListViewController() {
    ChatUIKitProvider.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    super.dispose();
  }

  String? cursor;

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (list.any((element) =>
        map.keys.contains((element as NewRequestItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = list.indexWhere(
            (e) => (e as NewRequestItemModel).profile.id == element);
        if (index != -1) {
          list[index] = (list[index] as NewRequestItemModel)
              .copyWith(profile: map[element]!);
        }
      }
      refresh();
    }
  }

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List items = ChatUIKitContext.instance.requestList();
    List<NewRequestItemModel> tmp = mappers(items);
    list.clear();
    list.addAll(tmp);
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  List<NewRequestItemModel> mappers(List requests) {
    List<NewRequestItemModel> list = [];
    Map<String, ChatUIKitProfile> map =
        ChatUIKitProvider.instance.getProfiles(() {
      List<ChatUIKitProfile> list = [];
      for (var item in requests) {
        String userId = item['id'];
        list.add(ChatUIKitProfile.contact(id: userId));
      }
      return list;
    }());

    for (var item in map.entries) {
      NewRequestItemModel info = NewRequestItemModel.fromProfile(item.value);
      list.add(info);
    }
    return list;
  }
}
