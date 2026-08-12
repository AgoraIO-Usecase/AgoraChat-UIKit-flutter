import 'package:cached_network_image/cached_network_image.dart';

import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:agora_chat_uikit/chat_uikit_universal/chat_uikit_universal.dart';

import 'package:flutter/material.dart';

class ChatUIKitAvatar extends StatefulWidget {
  ChatUIKitAvatar.current({
    this.size = 32,
    this.cornerRadius,
    this.avatarUrl,
    this.onTap,
    super.key,
  }) : isGroup = false {
    isCurrent = true;
  }

  ChatUIKitAvatar({
    this.avatarUrl,
    this.size = 32,
    this.cornerRadius,
    this.onTap,
    this.isGroup = false,
    ValueKey? key,
  }) : super(key: key ?? ValueKey(avatarUrl)) {
    isCurrent = false;
  }
  final double size;
  final CornerRadius? cornerRadius;
  final String? avatarUrl;
  late final bool isCurrent;
  final VoidCallback? onTap;
  final bool isGroup;

  @override
  State<ChatUIKitAvatar> createState() => _ChatUIKitAvatarState();
}

class _ChatUIKitAvatarState extends State<ChatUIKitAvatar>
    with ChatUIKitProviderObserver {
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isCurrent) {
      ChatUIKitProvider.instance.addObserver(this);
    }

    avatarUrl = widget.avatarUrl;
  }

  @override
  void didUpdateWidget(covariant ChatUIKitAvatar oldWidget) {
    if (oldWidget.avatarUrl != avatarUrl) {
      avatarUrl = widget.avatarUrl;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.isCurrent) {
      ChatUIKitProvider.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map, [String? belongId]) {
    if (belongId?.isNotEmpty == true) {
      return;
    }
    if (map.keys.contains(ChatUIKit.instance.currentUserId)) {
      ChatUIKitProfile userData = map[ChatUIKit.instance.currentUserId]!;
      if (userData.avatarUrl?.isNotEmpty == true &&
          avatarUrl != userData.avatarUrl) {
        setState(() {
          avatarUrl = userData.avatarUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: widget.size,
      height: widget.size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          CornerRadiusHelper.avatarRadius(
            widget.size,
            cornerRadius: widget.cornerRadius,
          ),
        ),
      ),
      child: avatarUrl?.isNotEmpty == true
          ? CachedNetworkImage(
              imageUrl: avatarUrl!,
              errorListener: (value) {
                debugPrint('avatarUrl: $avatarUrl, error: $value');
              },
              width: widget.size,
              height: widget.size,
              fit: BoxFit.fill,
              placeholder: (context, url) {
                return ChatUIKitImageLoader.defaultAvatar(
                    height: widget.size,
                    width: widget.size,
                    isGroup: widget.isGroup);
              },
              errorWidget: (context, url, error) {
                return ChatUIKitImageLoader.defaultAvatar(
                    height: widget.size,
                    width: widget.size,
                    isGroup: widget.isGroup);
              },
            )
          : ChatUIKitImageLoader.defaultAvatar(
              height: widget.size, width: widget.size, isGroup: widget.isGroup),
    );

    content = InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: content,
    );
    return content;
  }
}
