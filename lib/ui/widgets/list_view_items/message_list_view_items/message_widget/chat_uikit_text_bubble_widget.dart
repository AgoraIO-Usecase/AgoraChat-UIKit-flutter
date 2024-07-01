import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../chat_uikit.dart';
import '../../../../../ui/widgets/chat_uikit_reg_exp_text.dart';



class ChatUIKitTextBubbleWidget extends StatelessWidget {
  const ChatUIKitTextBubbleWidget({
    required this.model,
    this.style,
    this.forceLeft,
    // this.exp,
    this.expHighlightColor,
    this.enableExpUnderline = true,
    this.onExpTap,
    super.key,
  });
  final TextStyle? style;
  final MessageModel model;
  final bool? forceLeft;
  // final RegExp? exp;
  final Color? expHighlightColor;
  final bool enableExpUnderline;

  final Function(String expStr)? onExpTap;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left =
        forceLeft ?? model.message.direction == MessageDirection.RECEIVE;

    String str = model.message.textContent;

    TextStyle tmpStyle = style ??
        (left
            ? TextStyle(
                fontWeight: theme.font.bodyLarge.fontWeight,
                fontSize: theme.font.bodyLarge.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1,
              )
            : TextStyle(
                fontWeight: theme.font.bodyLarge.fontWeight,
                fontSize: theme.font.bodyLarge.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor1
                    : theme.color.neutralColor98,
              ));

    List<Widget> contents = [];

    Widget content = ChatUIKitRegExpText(
      // exp: exp,
      onExpTap: onExpTap,
      enableExpUnderline: enableExpUnderline,
      expHighlightColor: expHighlightColor,
      text: str,
      style: tmpStyle,
    );

    contents.add(content);
    if (model.message.hasFetchingPreview()) {
      contents.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            ChatUIKitLocal.messageTextWidgetURLPreviewParsing
                .localString(context),
            style: TextStyle(
              fontWeight: theme.font.bodySmall.fontWeight,
              fontSize: theme.font.bodySmall.fontSize,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralColor7
                      : theme.color.neutralColor5
                  : theme.color.isDark
                      ? theme.color.primaryColor8
                      : theme.color.primaryColor9,
            ),
          ),
        ),
      );
    } else {
      ChatUIKitPreviewObj? obj = model.message.getPreview();
      if (obj != null) {
        if (obj.imageUrl?.isNotEmpty == true) {
          contents.add(
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  String imgUrl = obj.imageUrl!;
                  if (imgUrl.startsWith('//')) {
                    imgUrl = 'https:$imgUrl';
                  } else if (imgUrl.startsWith('/')) {
                    if (obj.url!.startsWith('http')) {
                      imgUrl = '${obj.url}$imgUrl';
                    } else {
                      imgUrl = 'https://${obj.url!}$imgUrl';
                    }
                  }
                  return FittedBox(
                    fit: BoxFit.none,
                    child: CachedNetworkImage(
                      height: 118,
                      width: constraints.maxWidth + 24,
                      imageUrl: imgUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Container(
                          height: 118,
                          width: 300,
                          color: theme.color.isDark
                              ? theme.color.neutralColor3
                              : theme.color.neutralColor95,
                        );
                      },
                      errorWidget: (context, url, error) {
                        debugPrint('urlPreview errorWidget: $url');
                        return Container(
                          height: 118,
                          width: 300,
                          color: theme.color.isDark
                              ? theme.color.neutralColor3
                              : theme.color.neutralColor95,
                        );
                      },
                      errorListener: (value) {
                        debugPrint('urlPreview errorListener: $value');
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }
        if (obj.title?.isNotEmpty == true) {
          contents.add(
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                obj.title!,
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
                  color: left
                      ? theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor1
                      : theme.color.isDark
                          ? theme.color.neutralColor1
                          : theme.color.neutralColor98,
                ),
              ),
            ),
          );
        }
        if (obj.description?.isNotEmpty == true) {
          contents.add(
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                obj.description!,
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: theme.font.bodyMedium.fontWeight,
                  fontSize: theme.font.bodyMedium.fontSize,
                  color: left
                      ? theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor1
                      : theme.color.isDark
                          ? theme.color.neutralColor1
                          : theme.color.neutralColor98,
                ),
              ),
            ),
          );
        }
      }
    }

    List<Widget> widgets = contents;

    if (model.message.isEdit) {
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                  child: ChatUIKitImageLoader.messageLongPressEdit(
                width: 16,
                height: 16,
                color: left
                    ? theme.color.isDark
                        ? theme.color.neutralSpecialColor7
                        : theme.color.neutralSpecialColor5
                    : theme.color.isDark
                        ? theme.color.neutralSpecialColor3
                        : theme.color.neutralSpecialColor98,
              )),
              TextSpan(
                text: ChatUIKitLocal.messageEdited.localString(context),
                style: TextStyle(
                  fontWeight: theme.font.labelSmall.fontWeight,
                  fontSize: theme.font.labelSmall.fontSize,
                  color: left
                      ? theme.color.isDark
                          ? theme.color.neutralSpecialColor7
                          : theme.color.neutralSpecialColor5
                      : theme.color.isDark
                          ? theme.color.neutralSpecialColor3
                          : theme.color.neutralSpecialColor98,
                ),
              ),
            ],
          ),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    if (model.message.hasTranslate) {
      widgets.add(
        SizedBox(
            width: getSize(context, theme),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                height: 0.5,
                color: theme.color.isDark
                    ? theme.color.neutralColor3
                    : theme.color.neutralColor95,
              ),
            )),
      );
      widgets.add(
        ChatUIKitRegExpText(
          text: model.message.translateText,
          // exp: exp,
          onExpTap: onExpTap,
          enableExpUnderline: enableExpUnderline,
          expHighlightColor: expHighlightColor,
          style: TextStyle(
            fontWeight: theme.font.bodyLarge.fontWeight,
            fontSize: theme.font.bodyLarge.fontSize,
            color: left
                ? theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1
                : theme.color.isDark
                    ? theme.color.neutralColor1
                    : theme.color.neutralColor98,
          ),
        ),
      );
      widgets.add(const SizedBox(height: 6));
      widgets.add(
        RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            children: [
              WidgetSpan(
                  child: ChatUIKitImageLoader.messageLongPressTranslate(
                width: 16,
                height: 16,
                color: left
                    ? theme.color.isDark
                        ? theme.color.neutralSpecialColor7
                        : theme.color.neutralSpecialColor5
                    : theme.color.isDark
                        ? theme.color.neutralSpecialColor3
                        : theme.color.neutralSpecialColor98,
              )),
              TextSpan(
                text: ChatUIKitLocal.messageTranslated.localString(context),
                style: TextStyle(
                  fontWeight: theme.font.labelSmall.fontWeight,
                  fontSize: theme.font.labelSmall.fontSize,
                  color: left
                      ? theme.color.isDark
                          ? theme.color.neutralSpecialColor7
                          : theme.color.neutralSpecialColor5
                      : theme.color.isDark
                          ? theme.color.neutralSpecialColor3
                          : theme.color.neutralSpecialColor98,
                ),
              ),
            ],
          ),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );

    return content;
  }

  double getSize(BuildContext context, ChatUIKitTheme theme) {
    TextStyle tmpStyle = TextStyle(
      fontWeight: theme.font.bodyLarge.fontWeight,
      fontSize: theme.font.bodyLarge.fontSize,
    );

    TextPainter painter1 = TextPainter(
      text: TextSpan(
        text: model.message.textContent,
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    TextPainter painter2 = TextPainter(
      text: TextSpan(
        text: model.message.translateText,
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    TextPainter painter3 = TextPainter(
      text: TextSpan(
        text: ChatUIKitLocal.messageTranslated.localString(context),
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    TextPainter painter4 = TextPainter(
      text: TextSpan(
        text: ChatUIKitLocal.messageEdited.localString(context),
        style: tmpStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return max(max(painter1.size.width, painter2.size.width),
            max(painter3.size.width, painter4.size.width)) +
        5;
  }
}
