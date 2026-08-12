/// Profile 类型，用于区分是联系人还是群组。
enum ChatUIKitProfileType {
  /// 联系人类型。
  contact,

  /// 聊天室类型。
  chatroom,

  /// 群类型。
  group,

  /// 自定义类型。
  custom,
}

/// ChatUIKitProfile class, used to store information about contacts or groups.
class ChatUIKitProfile {
  /// id, if it is a contact, it is the user id, if it is a group, it is the group id.
  final String id;

  /// show name, if it is a contact, it is the user nickname, if it is a group, it is the group name.
  final String? showName;

  /// avatar url, if it is a contact, it is the user avatar address, if it is a group, it is the group avatar address.
  final String? avatarUrl;

  /// Profile type, used to distinguish whether it is a contact or a group.
  final ChatUIKitProfileType type;

  /// Extension field, used to store some additional information.
  final Map<String, Object> extension;

  /// Timestamp, not used internally by uikit. Developers can use this field to store some timestamp information.
  final int timestamp;

  /// Remark, if it is a contact, it is the remark information.
  final String? remark;

  /// The name used for display, if the name is empty, the id is displayed.
  String get contactShowName {
    if (remark != null &&
        remark!.isNotEmpty &&
        type == ChatUIKitProfileType.contact) {
      return remark!;
    }

    if (showName != null && showName!.isNotEmpty) {
      return showName!;
    }
    return id;
  }

  /// The nickname used for display, if the name is empty, the id is displayed.
  String get nickname {
    if (showName != null && showName!.isNotEmpty) {
      return showName!;
    }
    return id;
  }

  /// Constructor, used to create a profile object.
  /// [id] is the user id.
  /// [showName] is the show name. when type is contact, it is the user nickname, when type is group, it is the group name.
  /// [avatarUrl] is the user avatar address.
  /// [type] is the profile type.
  /// [remark] is the user remark information.
  /// [timestamp] is the timestamp.
  /// [extension] is the extension field.
  ChatUIKitProfile({
    required this.id,
    required this.type,
    this.showName,
    this.avatarUrl,
    this.remark,
    this.timestamp = 0,
    Map<String, Object>? extension,
  }) : extension = extension ?? <String, Object>{};

  /// Create a contact profile object.
  /// [id] is the user id.
  /// [nickname] is the user name.
  /// [avatarUrl] is the user avatar address.
  /// [remark] is the user remark information.
  /// [timestamp] is the timestamp.
  /// [extension] is the extension field.
  ChatUIKitProfile.contact({
    required String id,
    String? nickname,
    String? avatarUrl,
    String? remark,
    int timestamp = 0,
    Map<String, Object>? extension,
  }) : this(
          id: id,
          showName: nickname,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.contact,
          remark: remark,
          timestamp: timestamp,
          extension: extension,
        );

  /// Create a group profile object.
  /// [id] is the group id.
  /// [groupName] is the group name.
  /// [avatarUrl] is the group avatar address.
  /// [timestamp] is the timestamp.
  /// [extension] is the extension field.
  ChatUIKitProfile.group({
    required String id,
    String? groupName,
    String? avatarUrl,
    int timestamp = 0,
    Map<String, Object>? extension,
  }) : this(
          id: id,
          showName: groupName,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.group,
          timestamp: timestamp,
          extension: extension,
        );

  ChatUIKitProfile.chatroom({
    required String id,
    String? groupName,
    String? avatarUrl,
    int timestamp = 0,
    Map<String, Object>? extension,
  }) : this(
          id: id,
          showName: groupName,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.chatroom,
          timestamp: timestamp,
          extension: extension,
        );

  /// Create a custom profile object.
  /// [id] is the id.
  /// [showName] is the show name.
  /// [avatarUrl] is the avatar address.
  /// [remark] is the remark information.
  /// [timestamp] is the timestamp.
  /// [extension] is the extension field.
  ChatUIKitProfile.custom({
    required String id,
    String? showName,
    String? avatarUrl,
    String? remark,
    int timestamp = 0,
    Map<String, Object>? extension,
  }) : this(
          id: id,
          showName: showName,
          avatarUrl: avatarUrl,
          type: ChatUIKitProfileType.custom,
          remark: remark,
          timestamp: timestamp,
          extension: extension ?? <String, Object>{},
        );

  ///
  /// Copy the current object and modify the specified attributes.
  /// [showName] is the show name. when type is contact, it is the user nickname, when type is group, it is the group name.
  /// [avatarUrl] is the user avatar address.
  /// [remark] is the user remark information.
  /// [timestamp] is the timestamp.
  /// [extension] is the extension field.
  ChatUIKitProfile copyWith({
    String? showName,
    String? avatarUrl,
    String? remark,
    int? timestamp,
    Map<String, Object>? extension,
  }) {
    final profile = ChatUIKitProfile(
      id: id,
      showName: showName ?? this.showName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type,
      extension: extension ?? this.extension,
      timestamp: timestamp ?? this.timestamp,
      remark: remark ?? this.remark,
    );
    return profile;
  }

  @override
  String toString() {
    return "id: $id, nickname: $showName, type: $type, avatar: $avatarUrl, remark: $remark \n";
  }
}
