import 'package:agora_chat_uikit/chat_uikit.dart';

import 'package:example/demo/tool/user_data_store.dart';
import 'package:flutter/material.dart';

class UserProviderWidget extends StatefulWidget {
  const UserProviderWidget({required this.child, super.key});

  final Widget child;

  @override
  State<UserProviderWidget> createState() => _UserProviderWidgetState();
}

class _UserProviderWidgetState extends State<UserProviderWidget>
    with GroupObserver {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    // Open DB
    UserDataStore().init(onOpened: onOpened);
    // Set Provider Handler
    ChatUIKitProvider.instance.profilesHandler = onProfilesRequest;
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onOpened() async {
    // 1. Fill all stored data into uikit.
    await addAllUserInfoToProvider();
    // 2. Load group information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
    await loadGroupInfos();
    // 2. Load user information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
    await loadUserInfos();
    // 3. etch current user information, then fill it into uikit.
    await fetchCurrentUserInfo();
  }

  Future<void> fetchCurrentUserInfo() async {
    try {
      // Do not retrieve own data from the db, always fetch the latest data from the server.
      Map<String, UserInfo> map = await ChatUIKit.instance.fetchUserInfoByIds([
        ChatUIKit.instance.currentUserId!,
      ]);
      ChatUIKitProfile profile = ChatUIKitProfile.contact(
        id: map.values.first.userId,
        nickname: map.values.first.nickName,
        avatarUrl: map.values.first.avatarUrl,
      );
      UserDataStore().saveUserData(profile);
      ChatUIKitProvider.instance.addProfiles([profile]);
    } catch (e) {
      debugPrint('fetchCurrentUserInfo error: $e');
    }
  }

  // This method is called when uikit needs to display user information and the cache does not exist;
  // it requires fetching and storing the information in the db based on user attributes.
  List<ChatUIKitProfile>? onProfilesRequest(
    List<ChatUIKitProfile> profiles, [
    String? belongId,
  ]) {
    List<String> userIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.contact)
        .map((e) => e.id)
        .toList();
    if (userIds.isNotEmpty) {
      fetchUserInfos(userIds);
    }

    List<String> groupIds = profiles
        .where((e) => e.type == ChatUIKitProfileType.group)
        .map((e) => e.id)
        .toList();
    updateGroupsProfile(groupIds);
    return profiles;
  }

  // When a group is created by oneself, it is necessary to fill the group information into uikit.
  @override
  void onGroupCreatedByMyself(Group group) async {
    ChatUIKitProfile profile = ChatUIKitProfile.group(
      id: group.groupId,
      groupName: group.name,
    );

    ChatUIKitProvider.instance.addProfiles([profile]);
    // save to db
    UserDataStore().saveUserData(profile);
  }

  // When the group name is changed by oneself, it is necessary to update the group information in uikit.
  @override
  void onGroupNameChangedByMeSelf(Group group) {
    ChatUIKitProfile? profile = ChatUIKitProvider.instance.getProfileById(
      group.groupId,
    );

    profile = profile?.copyWith(showName: group.name) ??
        ChatUIKitProfile.group(id: group.groupId, groupName: group.name);

    ChatUIKitProvider.instance.addProfiles([profile]);
    // save to db
    UserDataStore().saveUserData(profile);
  }

  // Fill all stored data into uikit.
  Future<void> addAllUserInfoToProvider() async {
    List<ChatUIKitProfile> list = await UserDataStore().loadAllProfiles();
    ChatUIKitProvider.instance.addProfiles(list);
  }

  // Load group information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
  Future<void> loadGroupInfos() async {
    List<Group> groups = await ChatUIKit.instance.getJoinedGroups();
    List<ChatUIKitProfile> profiles = groups
        .map(
          (e) => ChatUIKitProfile.group(id: e.groupId, groupName: e.name),
        )
        .toList();

    if (profiles.isNotEmpty) {
      UserDataStore().saveUserDatas(profiles);
      ChatUIKitProvider.instance.addProfiles(profiles);
    }
  }

  Future<void> updateGroupsProfile(List<String> groupIds) async {
    List<ChatUIKitProfile> list = [];
    for (var groupId in groupIds) {
      try {
        Group group = await ChatUIKit.instance.fetchGroupInfo(groupId: groupId);
        ChatUIKitProfile profile = ChatUIKitProfile.group(
          id: group.groupId,
          groupName: group.name,
          avatarUrl: group.extension,
        );
        list.add(profile);
      } on ChatError catch (e) {
        if (e.code == 600) {
          // 600 indicates the group does not exist, unable to fetch data, providing default data.
          ChatUIKitProfile profile = ChatUIKitProfile.group(id: groupId);
          list.add(profile);
        }
        debugPrint('loadGroupInfo error: $e');
      }
    }
    UserDataStore().saveUserDatas(list);
    ChatUIKitProvider.instance.addProfiles(list);
  }

  // Load user information, and check if it has been filled into uikit. If not, fetch data from the server and then fill it into uikit.
  Future<void> loadUserInfos() async {
    try {
      Map<String, ChatUIKitProfile> map =
          ChatUIKitProvider.instance.profilesCache;
      List<Contact> contacts = await ChatUIKit.instance.getAllContacts();
      contacts.removeWhere((element) => map.keys.contains(element.userId));
      if (contacts.isNotEmpty) {
        List<String> userIds = contacts.map((e) => e.userId).toList();
        fetchUserInfos(userIds);
      }
    } catch (e) {
      debugPrint('loadUserInfos error: $e');
    }
  }

  void fetchUserInfos(List<String> userIds) async {
    try {
      Map<String, UserInfo> map = await ChatUIKit.instance.fetchUserInfoByIds(
        userIds,
      );
      List<ChatUIKitProfile> list = map.values
          .map(
            (e) => ChatUIKitProfile.contact(
              id: e.userId,
              nickname: e.nickName,
              avatarUrl: e.avatarUrl,
            ),
          )
          .toList();

      if (list.isNotEmpty) {
        UserDataStore().saveUserDatas(list);
        ChatUIKitProvider.instance.addProfiles(list);
      }
    } catch (e) {
      debugPrint('fetchUserInfos error: $e');
    }
  }
}
