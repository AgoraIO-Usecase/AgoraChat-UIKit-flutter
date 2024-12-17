import '../chat_sdk_service.dart';

mixin RoomActions on RoomWrapper {
  Future<void> joinChatRoom({
    required String roomId,
  }) async {
    return checkResult(ChatSDKEvent.joinChatRoom, () {
      return Client.getInstance.chatRoomManager.joinChatRoom(roomId);
    });
  }

  Future<void> leaveChatRoom(String roomId) async {
    return checkResult(ChatSDKEvent.leaveChatRoom, () {
      return Client.getInstance.chatRoomManager.leaveChatRoom(roomId);
    });
  }

  Future<PageResult<ChatRoom>> fetchPublicChatRoomsFromServer({
    int pageNum = 1,
    int pageSize = 200,
  }) {
    return checkResult(ChatSDKEvent.fetchPublicChatRoomsFromServer, () {
      return Client.getInstance.chatRoomManager.fetchPublicChatRoomsFromServer(
        pageNum: pageNum,
        pageSize: pageSize,
      );
    });
  }

  Future<ChatRoom> fetchChatRoomInfoFromServer({
    required String roomId,
    bool fetchMembers = false,
  }) {
    return checkResult(ChatSDKEvent.fetchChatRoomInfoFromServer, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomInfoFromServer(
        roomId,
        fetchMembers: fetchMembers,
      );
    });
  }

  Future<ChatRoom?> getChatRoomWithId(String roomId) {
    return checkResult(ChatSDKEvent.getChatRoomWithId, () {
      return Client.getInstance.chatRoomManager.getChatRoomWithId(roomId);
    });
  }

  Future<ChatRoom> createChatRoom({
    required String name,
    String? desc,
    String? welcomeMsg,
    int maxUserCount = 300,
    List<String>? members,
  }) {
    return checkResult(ChatSDKEvent.createChatRoom, () {
      return Client.getInstance.chatRoomManager.createChatRoom(name,
          desc: desc,
          welcomeMsg: welcomeMsg,
          maxUserCount: maxUserCount,
          members: members);
    });
  }

  Future<void> destroyChatRoom(
    String roomId,
  ) {
    return checkResult(ChatSDKEvent.destroyChatRoom, () {
      return Client.getInstance.chatRoomManager.destroyChatRoom(roomId);
    });
  }

  Future<void> changeChatRoomName({
    required String roomId,
    required String name,
  }) {
    return checkResult(ChatSDKEvent.changeChatRoomName, () {
      return Client.getInstance.chatRoomManager.changeChatRoomName(
        roomId,
        name,
      );
    });
  }

  Future<void> changeChatRoomDescription({
    required String roomId,
    required String description,
  }) {
    return checkResult(ChatSDKEvent.changeChatRoomDescription, () {
      return Client.getInstance.chatRoomManager.changeChatRoomDescription(
        roomId,
        description,
      );
    });
  }

  Future<CursorResult<String>> fetchChatRoomMembers({
    required String roomId,
    String? cursor,
    int pageSize = 200,
  }) {
    return checkResult(ChatSDKEvent.fetchChatRoomMembers, () {
      return Client.getInstance.chatRoomManager
          .fetchChatRoomMembers(roomId, cursor: cursor, pageSize: pageSize);
    });
  }

  Future<void> muteChatRoomMembers({
    required String roomId,
    required List<String> muteMembers,
    int duration = -1,
  }) {
    return checkResult(ChatSDKEvent.muteChatRoomMembers, () {
      return Client.getInstance.chatRoomManager
          .muteChatRoomMembers(roomId, muteMembers, duration: duration);
    });
  }

  Future<void> unMuteChatRoomMembers({
    required String roomId,
    required List<String> unMuteMembers,
  }) {
    return checkResult(ChatSDKEvent.unMuteChatRoomMembers, () {
      return Client.getInstance.chatRoomManager
          .unMuteChatRoomMembers(roomId, unMuteMembers);
    });
  }

  Future<void> changeOwner({
    required String roomId,
    required String newOwner,
  }) {
    return checkResult(ChatSDKEvent.changeChatRoomOwner, () {
      return Client.getInstance.chatRoomManager.changeOwner(
        roomId,
        newOwner,
      );
    });
  }

  Future<void> addChatRoomAdmin({
    required String roomId,
    required String admin,
  }) {
    return checkResult(ChatSDKEvent.addChatRoomAdmin, () {
      return Client.getInstance.chatRoomManager.addChatRoomAdmin(
        roomId,
        admin,
      );
    });
  }

  Future<void> removeChatRoomAdmin({
    required String roomId,
    required String admin,
  }) {
    return checkResult(ChatSDKEvent.removeChatRoomAdmin, () {
      return Client.getInstance.chatRoomManager.removeChatRoomAdmin(
        roomId,
        admin,
      );
    });
  }

  Future<List<String>> fetchChatRoomMuteList({
    required String roomId,
    int pageNum = 1,
    int pageSize = 200,
  }) {
    return checkResult(ChatSDKEvent.fetchChatRoomMuteList, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomMuteList(
        roomId,
        pageNum: pageNum,
        pageSize: pageSize,
      );
    });
  }

  Future<void> removeChatRoomMembers({
    required String roomId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.removeChatRoomMembers, () {
      return Client.getInstance.chatRoomManager.removeChatRoomMembers(
        roomId,
        members,
      );
    });
  }

  Future<void> blockChatRoomMembers({
    required String roomId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.blockChatRoomMembers, () {
      return Client.getInstance.chatRoomManager.blockChatRoomMembers(
        roomId,
        members,
      );
    });
  }

  Future<void> unBlockChatRoomMembers({
    required String roomId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.unBlockChatRoomMembers, () async {
      return Client.getInstance.chatRoomManager.unBlockChatRoomMembers(
        roomId,
        members,
      );
    });
  }

  Future<List<String>> fetchChatRoomBlockList({
    required String roomId,
    int pageNum = 1,
    int pageSize = 200,
  }) {
    return checkResult(ChatSDKEvent.fetchChatRoomBlockList, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomBlockList(
        roomId,
        pageNum: pageNum,
        pageSize: pageSize,
      );
    });
  }

  Future<void> updateChatRoomAnnouncement({
    required String roomId,
    required String announcement,
  }) {
    return checkResult(ChatSDKEvent.updateChatRoomAnnouncement, () {
      return Client.getInstance.chatRoomManager
          .updateChatRoomAnnouncement(roomId, announcement);
    });
  }

  Future<String?> fetchChatRoomAnnouncement({
    required String roomId,
  }) {
    return checkResult(ChatSDKEvent.fetchChatRoomAnnouncement, () {
      return Client.getInstance.chatRoomManager
          .fetchChatRoomAnnouncement(roomId);
    });
  }

  Future<List<String>> fetchChatRoomAllowListFromServer(
      {required String roomId}) {
    return checkResult(ChatSDKEvent.fetchChatRoomAllowListFromServer, () {
      return Client.getInstance.chatRoomManager
          .fetchChatRoomAllowListFromServer(roomId);
    });
  }

  Future<bool> isMemberInChatRoomAllowList({required String roomId}) {
    return checkResult(ChatSDKEvent.isMemberInChatRoomAllowList, () {
      return Client.getInstance.chatRoomManager
          .isMemberInChatRoomAllowList(roomId);
    });
  }

  Future<void> addMembersToChatRoomAllowList({
    required String roomId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.addMembersToChatRoomAllowList, () {
      return Client.getInstance.chatRoomManager.addMembersToChatRoomAllowList(
        roomId,
        members,
      );
    });
  }

  Future<void> removeMembersFromChatRoomAllowList({
    required String roomId,
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.removeMembersFromChatRoomAllowList, () {
      return Client.getInstance.chatRoomManager
          .removeMembersFromChatRoomAllowList(
        roomId,
        members,
      );
    });
  }

  Future<void> muteAllChatRoomMembers({required String roomId}) {
    return checkResult(ChatSDKEvent.muteAllChatRoomMembers, () {
      return Client.getInstance.chatRoomManager.muteAllChatRoomMembers(roomId);
    });
  }

  Future<void> unMuteAllChatRoomMembers({required String roomId}) {
    return checkResult(ChatSDKEvent.unMuteAllChatRoomMembers, () {
      return Client.getInstance.chatRoomManager
          .unMuteAllChatRoomMembers(roomId);
    });
  }

  Future<Map<String, String>?> fetchChatRoomAttributes({
    required String roomId,
    List<String>? keys,
  }) {
    return checkResult(ChatSDKEvent.fetchChatRoomAttributes, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomAttributes(
        roomId: roomId,
        keys: keys,
      );
    });
  }

  Future<Map<String, int>?> addAttributes({
    required String roomId,
    required Map<String, String> attributes,
    bool deleteWhenLeft = false,
    bool overwrite = false,
  }) {
    return checkResult(ChatSDKEvent.addChatRoomAttributes, () {
      return Client.getInstance.chatRoomManager.addAttributes(roomId,
          attributes: attributes,
          deleteWhenLeft: deleteWhenLeft,
          overwrite: overwrite);
    });
  }

  Future<Map<String, int>?> removeAttributes({
    required String roomId,
    required List<String> keys,
    bool force = false,
  }) {
    return checkResult(ChatSDKEvent.removeChatRoomAttributes, () {
      return Client.getInstance.chatRoomManager.removeAttributes(
        roomId,
        keys: keys,
        force: force,
      );
    });
  }
}
