import '../chat_sdk_wrapper.dart';
import 'package:flutter/foundation.dart';

mixin GroupWrapper on ChatUIKitWrapperBase {
  @protected
  @override
  void addListeners() {
    super.addListeners();
    Client.getInstance.groupManager.addEventHandler(
      sdkEventKey,
      GroupEventHandler(
        onGroupDestroyed: onGroupDestroyed,
        onAdminAddedFromGroup: onAdminAddedFromGroup,
        onAdminRemovedFromGroup: onAdminRemovedFromGroup,
        onAllGroupMemberMuteStateChanged: onAllGroupMemberMuteStateChanged,
        onAllowListAddedFromGroup: onAllowListAddedFromGroup,
        onAllowListRemovedFromGroup: onAllowListRemovedFromGroup,
        onAnnouncementChangedFromGroup: onAnnouncementChangedFromGroup,
        onAutoAcceptInvitationFromGroup: onAutoAcceptInvitationFromGroup,
        onInvitationAcceptedFromGroup: onInvitationAcceptedFromGroup,
        onInvitationDeclinedFromGroup: onInvitationDeclinedFromGroup,
        onInvitationReceivedFromGroup: onInvitationReceivedFromGroup,
        onMemberExitedFromGroup: onMemberExitedFromGroup,
        onMemberJoinedFromGroup: onMemberJoinedFromGroup,
        onMuteListAddedFromGroup: onMuteListAddedFromGroup,
        onMuteListRemovedFromGroup: onMuteListRemovedFromGroup,
        onOwnerChangedFromGroup: onOwnerChangedFromGroup,
        onRequestToJoinAcceptedFromGroup: onRequestToJoinAcceptedFromGroup,
        onRequestToJoinDeclinedFromGroup: onRequestToJoinDeclinedFromGroup,
        onRequestToJoinReceivedFromGroup: onRequestToJoinReceivedFromGroup,
        onSharedFileAddedFromGroup: onSharedFileAddedFromGroup,
        onSpecificationDidUpdate: onSpecificationDidUpdate,
        onDisableChanged: onDisableChanged,
        onSharedFileDeletedFromGroup: onSharedFileDeletedFromGroup,
        onUserRemovedFromGroup: onUserRemovedFromGroup,
        onAttributesChangedOfGroupMember: onAttributesChangedOfGroupMember,
      ),
    );
  }

  @override
  void removeListeners() {
    super.removeListeners();
    Client.getInstance.groupManager.removeEventHandler(sdkEventKey);
  }

  @protected
  void onGroupDestroyed(String groupId, String? groupName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onGroupDestroyed(groupId, groupName);
      }
    }
  }

  @protected
  void onAdminAddedFromGroup(String groupId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAdminAddedFromGroup(groupId, admin);
      }
    }
  }

  @protected
  void onAdminRemovedFromGroup(String groupId, String admin) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAdminRemovedFromGroup(groupId, admin);
      }
    }
  }

  @protected
  void onAllGroupMemberMuteStateChanged(String groupId, bool isAllMuted) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAllGroupMemberMuteStateChanged(groupId, isAllMuted);
      }
    }
  }

  @protected
  void onAllowListAddedFromGroup(String groupId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAllowListAddedFromGroup(groupId, members);
      }
    }
  }

  @protected
  void onAllowListRemovedFromGroup(String groupId, List<String> members) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAllowListRemovedFromGroup(groupId, members);
      }
    }
  }

  @protected
  void onAnnouncementChangedFromGroup(String groupId, String announcement) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAnnouncementChangedFromGroup(groupId, announcement);
      }
    }
  }

  @protected
  void onAutoAcceptInvitationFromGroup(
      String groupId, String inviter, String? inviteMessage) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAutoAcceptInvitationFromGroup(
            groupId, inviter, inviteMessage);
      }
    }
  }

  @protected
  void onInvitationAcceptedFromGroup(
      String groupId, String invitee, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onInvitationAcceptedFromGroup(groupId, invitee, reason);
      }
    }
  }

  @protected
  void onInvitationDeclinedFromGroup(
      String groupId, String invitee, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onInvitationDeclinedFromGroup(groupId, invitee, reason);
      }
    }
  }

  @protected
  void onInvitationReceivedFromGroup(
      String groupId, String? groupName, String inviter, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onInvitationReceivedFromGroup(
            groupId, groupName, inviter, reason);
      }
    }
  }

  @protected
  void onMemberExitedFromGroup(String groupId, String member) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onMemberExitedFromGroup(groupId, member);
      }
    }
  }

  @protected
  void onMemberJoinedFromGroup(String groupId, String member) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onMemberJoinedFromGroup(groupId, member);
      }
    }
  }

  @protected
  void onMuteListAddedFromGroup(
      String groupId, List<String> mutes, int? muteExpire) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onMuteListAddedFromGroup(groupId, mutes, muteExpire);
      }
    }
  }

  @protected
  void onMuteListRemovedFromGroup(String groupId, List<String> mutes) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onMuteListRemovedFromGroup(groupId, mutes);
      }
    }
  }

  @protected
  void onOwnerChangedFromGroup(
      String groupId, String newOwner, String oldOwner) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onOwnerChangedFromGroup(groupId, newOwner, oldOwner);
      }
    }
  }

  @protected
  void onRequestToJoinAcceptedFromGroup(
      String groupId, String? groupName, String accepter) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onRequestToJoinAcceptedFromGroup(groupId, groupName, accepter);
      }
    }
  }

  @protected
  void onRequestToJoinDeclinedFromGroup(
    String groupId,
    String? groupName,
    String? decliner,
    String? reason,
    String? applicant,
  ) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onRequestToJoinDeclinedFromGroup(
            groupId, groupName, decliner, reason, applicant);
      }
    }
  }

  @protected
  void onRequestToJoinReceivedFromGroup(
      String groupId, String? groupName, String applicant, String? reason) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onRequestToJoinReceivedFromGroup(
            groupId, groupName, applicant, reason);
      }
    }
  }

  @protected
  void onSharedFileAddedFromGroup(String groupId, GroupSharedFile sharedFile) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onSharedFileAddedFromGroup(groupId, sharedFile);
      }
    }
  }

  @protected
  void onSpecificationDidUpdate(Group group) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onSpecificationDidUpdate(group);
      }
    }
  }

  @protected
  void onDisableChanged(String groupId, bool isDisable) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onDisableChanged(groupId, isDisable);
      }
    }
  }

  @protected
  void onSharedFileDeletedFromGroup(String groupId, String fileId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onSharedFileDeletedFromGroup(groupId, fileId);
      }
    }
  }

  @protected
  void onUserRemovedFromGroup(String groupId, String? groupName) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onUserRemovedFromGroup(groupId, groupName);
      }
    }
  }

  @protected
  void onAttributesChangedOfGroupMember(String groupId, String userId,
      Map<String, String>? attributes, String? operatorId) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onAttributesChangedOfGroupMember(
            groupId, userId, attributes, operatorId);
      }
    }
  }

  void onGroupCreatedByMyself(Group group) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onGroupCreatedByMyself(group);
      }
    }
  }

  void onGroupNameChangedByMeSelf(Group group) {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is GroupObserver) {
        observer.onGroupNameChangedByMeSelf(group);
      }
    }
  }
}
