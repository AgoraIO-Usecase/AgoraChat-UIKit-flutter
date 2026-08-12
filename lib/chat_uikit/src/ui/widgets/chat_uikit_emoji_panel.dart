import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit_universal/chat_uikit_universal.dart';
import 'package:flutter/material.dart';

class ChatUIKitEmojiPanel extends StatelessWidget {
  final double maxCrossAxisExtent;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final double bigSizeRatio;

  final void Function(String emoji)? emojiClicked;

  final VoidCallback? deleteOnTap;

  final EdgeInsets? padding;

  final List<String>? selectedEmojis;

  final Color? selectedColor;

  const ChatUIKitEmojiPanel({
    super.key,
    this.maxCrossAxisExtent = 36,
    this.mainAxisSpacing = 19.0,
    this.crossAxisSpacing = 19.0,
    this.childAspectRatio = 1.0,
    this.bigSizeRatio = 0.0,
    this.emojiClicked,
    this.padding,
    this.deleteOnTap,
    this.selectedColor,
    this.selectedEmojis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    // Widget content = GridView.custom(
    //   shrinkWrap: true,
    //   padding: padding ??
    //       const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 60),
    //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //     maxCrossAxisExtent: maxCrossAxisExtent,
    //     mainAxisSpacing: mainAxisSpacing,
    //     crossAxisSpacing: crossAxisSpacing,
    //     childAspectRatio: childAspectRatio,
    //     mainAxisExtent: maxCrossAxisExtent,
    //   ),
    //   childrenDelegate: SliverChildBuilderDelegate(
    //     (context, position) => _getEmojiItemContainer(position),
    //     childCount: ChatUIKitEmojiData.listSize,
    //   ),
    // );

    // 计算顶部空白高度：约为半个 emoji 图标高度
    // emoji 图标大小 = 32px，加上 padding 和间距约 36px
    // 半个图标高度约为 18px，我们使用 20px 便于调整
    const double topSpacerHeight = 20.0;

    Widget content = Column(
      children: [
        // 顶部空白区域，当键盘弹出时这部分会被遮挡
        const SizedBox(height: topSpacerHeight),
        // Emoji 网格，使用 Expanded 填充剩余空间
        Expanded(
          child: GridView.custom(
            shrinkWrap: true,
            padding: padding ??
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 60),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
              mainAxisExtent: maxCrossAxisExtent,
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, position) => _getEmojiItemContainer(position),
              childCount: ChatUIKitEmojiData.listSize,
            ),
          ),
        ),
      ],
    );

    content = Container(
      // color: Colors.red,
      color: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      child: content,
    );
    if (deleteOnTap != null) {
      content = Stack(
        children: [
          content,
          Positioned(
            right: 20,
            bottom: 20,
            width: 36,
            height: 36,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                deleteOnTap?.call();
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: theme.color.isDark
                      ? ChatUIKitShadow.darkSmall
                      : ChatUIKitShadow.lightSmall,
                  borderRadius: BorderRadius.circular(24),
                  color: (theme.color.isDark
                      ? theme.color.neutralColor3
                      : theme.color.neutralColor98),
                ),
                child: ChatUIKitImageLoader.emojiDelete(
                  size: 20,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor3),
                ),
              ),
            ),
          ),
        ],
      );
    }

    content = ShaderMask(
      shaderCallback: (bounds) {
        final color = theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98;
        return LinearGradient(
          colors: [
            color,
            color,
            Colors.transparent,
          ],
          stops: const [0.05, 0.9, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: content,
    );

    return content;
  }

  _getEmojiItemContainer(int index) {
    var emojiPath = ChatUIKitEmojiData.emojiImagePaths[index];
    bool highlight =
        selectedEmojis?.contains(ChatUIKitEmojiData.getEmoji(emojiPath)) ??
            false;
    return ChatExpression(
      emojiPath,
      bigSizeRatio,
      emojiClicked,
      highlightedColor: selectedColor,
      highlighted: highlight,
    );
  }
}

class ChatExpression extends StatelessWidget {
  final String emojiName;

  final double bigSizeRatio;

  final void Function(String emoji)? emojiClicked;

  final bool highlighted;

  final Color? highlightedColor;

  const ChatExpression(
    this.emojiName,
    this.bigSizeRatio,
    this.emojiClicked, {
    this.highlighted = false,
    this.highlightedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Image.asset(
      emojiName,
      package: ChatUIKitEmojiData.packageName,
      width: 32,
      height: 32,
    );
    return Container(
      padding: const EdgeInsets.all(3.2),
      decoration: BoxDecoration(
        color: highlighted ? highlightedColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          emojiClicked?.call(emojiName);
        },
        child: icon,
      ),
    );
  }
}
