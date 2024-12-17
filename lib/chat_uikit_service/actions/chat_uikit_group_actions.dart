import '../../chat_uikit.dart';

mixin ChatUIKitGroupActions on ChatSDKService {
  @override
  Future<void> destroyGroup({required String groupId}) async {
    await super.destroyGroup(groupId: groupId);
    await ChatUIKitInsertTools.insertGroupDestroyMessage(groupId);
  }

  @override
  Future<void> leaveGroup({required String groupId}) async {
    await super.leaveGroup(groupId: groupId);
    await ChatUIKitInsertTools.insertGroupLeaveMessage(groupId);
  }

  @override
  Future<Group> createGroup({
    required String groupName,
    String? desc,
    List<String>? inviteMembers,
    String? inviteReason,
    required GroupOptions options,
  }) async {
    Group group = await super.createGroup(
      groupName: groupName,
      desc: desc,
      options: options,
      inviteMembers: inviteMembers,
      inviteReason: inviteReason,
    );
    await ChatUIKitInsertTools.insertCreateGroupMessage(group: group);
    return group;
  }
}
