import '../../chat_uikit.dart';

class NewRequestListViewController with ChatUIKitListViewControllerBase {
  NewRequestListViewController();

  String? cursor;

  @override
  Future<void> fetchItemList({bool force = false}) async {
    loadingType.value = ChatUIKitListViewType.refresh;
    List items = ChatUIKitContext.instance.requestList();
    List<NewRequestItemModel> tmp = mapperToNewRequestItemModelItems(items);
    list.clear();
    list.addAll(tmp);
    if (list.isEmpty) {
      loadingType.value = ChatUIKitListViewType.empty;
    } else {
      loadingType.value = ChatUIKitListViewType.normal;
    }
  }

  List<NewRequestItemModel> mapperToNewRequestItemModelItems(List requests) {
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

  Future<void> acceptRequest(String userId) async {
    try {
      await ChatUIKit.instance.acceptContactRequest(userId: userId);

      list.removeWhere((element) {
        if (element is NewRequestItemModel) {
          return element.profile.id == userId;
        } else {
          return false;
        }
      });
      // ignore: empty_catches
    } catch (e) {}
    refresh();
  }
}
