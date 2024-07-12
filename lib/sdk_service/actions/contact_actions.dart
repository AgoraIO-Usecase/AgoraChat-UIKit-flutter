import '../chat_sdk_wrapper.dart';

mixin ContactActions on ContactWrapper {
  Future<void> updateContactRemark(String userId, String remark) async {
    return checkResult(ChatSDKEvent.updateContactRemark, () {
      return Client.getInstance.contactManager
          .setContactRemark(userId: userId, remark: remark);
    });
  }

  Future<Contact?> getContact(String userId) {
    return checkResult(ChatSDKEvent.getAllContacts, () {
      return Client.getInstance.contactManager.getContact(userId: userId);
    });
  }

  Future<List<Contact>> getAllContacts() {
    return checkResult(ChatSDKEvent.getAllContacts, () {
      return Client.getInstance.contactManager.getAllContacts();
    });
  }

  Future<List<String>> getAllContactIds() {
    return checkResult(ChatSDKEvent.getAllContactIds, () {
      return Client.getInstance.contactManager.getAllContactIds();
    });
  }

  Future<void> sendContactRequest({required String userId, String? reason}) {
    return checkResult(ChatSDKEvent.sendContactRequest, () {
      return Client.getInstance.contactManager
          .addContact(userId, reason: reason);
    });
  }

  Future<void> acceptContactRequest({required String userId}) {
    return checkResult(ChatSDKEvent.acceptContactRequest, () {
      return Client.getInstance.contactManager.acceptInvitation(userId);
    });
  }

  Future<void> declineContactRequest({required String userId}) {
    return checkResult(ChatSDKEvent.declineContactRequest, () {
      return Client.getInstance.contactManager.declineInvitation(userId);
    });
  }

  Future<void> deleteContact({required String userId}) {
    return checkResult(ChatSDKEvent.deleteContact, () {
      return Client.getInstance.contactManager.deleteContact(userId);
    });
  }

  Future<List<String>> fetchAllContactIds() {
    return checkResult(ChatSDKEvent.fetchAllContactIds, () {
      return Client.getInstance.contactManager.fetchAllContactIds();
    });
  }

  Future<List<Contact>> fetchAllContacts() {
    return checkResult(ChatSDKEvent.fetchAllContacts, () {
      return Client.getInstance.contactManager.fetchAllContacts();
    });
  }

  Future<List<String>> fetchAllBlockedContactIds() {
    return checkResult(ChatSDKEvent.fetchAllBlockedContactIds, () {
      return Client.getInstance.contactManager.fetchBlockIds();
    });
  }

  Future<List<String>> getAllBlockedContactIds() {
    return checkResult(ChatSDKEvent.getAllBlockedContactIds, () {
      return Client.getInstance.contactManager.getBlockIds();
    });
  }

  Future<void> addBlockedContact({required String userId}) {
    return checkResult(ChatSDKEvent.addBlockedContact, () {
      return Client.getInstance.contactManager.addUserToBlockList(userId);
    });
  }

  Future<void> deleteBlockedContact({required String userId}) {
    return checkResult(ChatSDKEvent.deleteBlockedContact, () {
      return Client.getInstance.contactManager.removeUserFromBlockList(userId);
    });
  }
}
