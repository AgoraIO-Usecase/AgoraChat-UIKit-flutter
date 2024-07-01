enum ChatSDKEvent {
  loginWithPassword,
  loginWithToken,
  logout,
  sendMessage,
  sendTypingMessage,
  recallMessage,
  loadMessage,
  sendMessageReadAck,
  sendGroupMessageReadAck,
  sendConversationReadAck,
  createConversation,
  getConversation,
  getThreadConversation,
  markAllConversationsAsRead,
  markConversationAsRead,
  getUnreadMessageCount,
  getAppointUnreadCount,
  haveNewMessageConversationCount,
  updateMessage,
  importMessages,
  downloadAttachment,
  downloadThumbnail,
  downloadMessageAttachmentInCombine,
  downloadMessageThumbnailInCombine,
  loadAllConversations,
  fetchConversations,
  deleteRemoteMessagesWithIds,
  deleteRemoteMessagesBefore,
  deleteLocalConversation,
  fetchHistoryMessages,
  fetchHistoryMessagesByOptions,
  searchLocalMessage,
  searchConversationLocalMessage,
  fetchGroupAckList,
  deleteRemoteConversation,
  deleteLocalMessages,
  deleteLocalMessageById,
  deleteLocalThreadMessageById,
  deleteLocalMessageByIds,
  fetchPinnedMessages,
  loadPinnedMessages,
  pinMessage,
  unpinMessage,
  reportMessage,
  addReaction,
  deleteReaction,
  fetchReactionList,
  fetchReactionDetail,
  translateMessage,
  fetchSupportedLanguages,
  fetchPinnedConversations,
  pinConversation,
  modifyMessage,
  fetchCombineMessageDetail,
  updateContactRemark,
  getContact,
  getAllContactIds,
  getAllContacts,
  sendContactRequest,
  acceptContactRequest,
  declineContactRequest,
  deleteContact,
  fetchAllContactIds,
  fetchAllContacts,
  fetchAllBlockedContactIds,
  getAllBlockedContactIds,
  addBlockedContact,
  deleteBlockedContact,
  getGroupId,
  getJoinedGroups,
  fetchJoinedGroups,
  fetchPublicGroups,
  createGroup,
  fetchGroupInfo,
  fetchGroupMemberList,
  fetchGroupBlockList,
  fetchGroupMuteList,
  fetchGroupAllowList,
  fetchGroupMemberIsInAllowList,
  fetchGroupFileList,
  fetchGroupAnnouncement,
  addGroupMembers,
  inviterGroupMembers,
  deleteGroupMembers,
  addGroupBlockList,
  deleteGroupBlockList,
  changeGroupName,
  changeGroupDescription,
  leaveGroup,
  destroyGroup,
  blockGroup,
  unblockGroup,
  changeGroupOwner,
  addGroupAdmin,
  deleteGroupAdmin,
  addGroupMuteMembers,
  deleteGroupMuteMembers,
  muteGroupAllMembers,
  unMuteGroupAllMembers,
  addGroupAllowMembers,
  deleteGroupAllowMembers,
  uploadGroupSharedFile,
  downloadGroupSharedFile,
  removeGroupSharedFile,
  updateGroupAnnouncement,
  updateGroupExtension,
  joinPublicGroup,
  requestToJoinPublicGroup,
  fetchJoinedGroupCount,
  acceptGroupJoinApplication,
  declineGroupJoinApplication,
  acceptGroupInvitation,
  declineGroupInvitation,
  setGroupMemberAttributes,
  deleteGroupMemberAttributes,
  fetchGroupMemberAttributes,
  fetchGroupMembersAttributes,
  fetchPushConfig,
  uploadPushDisplayName,
  updatePushDisplayStyle,
  uploadHMSPushToken,
  uploadFCMPushToken,
  uploadAPNsPushToken,
  setSilentMode,
  clearSilentMode,
  fetchSilentModel,
  setAllSilentMode,
  publishPresence,
  subscribe,
  unsubscribe,
  fetchSubscribedMembers,
  fetchPresenceStatus,
  getMessages,
  loadLocalMessagesByTimestamp,
  fetchChatThread,
  fetchJoinedChatThreads,
  fetchChatThreadsWithParentId,
  fetchJoinedChatThreadsWithParentId,
  fetchChatThreadMembers,
  fetchLatestMessageWithChatThreads,
  removeMemberFromChatThread,
  updateChatThreadName,
  createChatThread,
  joinChatThread,
  chatThreadId,
  leaveChatThread,
  destroyChatThread,
  updateUserInfo,
  fetchOwnInfo,
  fetchUserInfoByIds,
}