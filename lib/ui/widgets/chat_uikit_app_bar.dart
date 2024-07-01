import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatUIKitAppBarModel {
  ChatUIKitAppBarModel({
    this.title,
    this.centerWidget,
    this.titleTextStyle,
    this.subtitle,
    this.subTitleTextStyle,
    this.leadingActions,
    this.leadingActionsBuilder,
    this.trailingActions,
    this.trailingActionsBuilder,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.centerTitle = false,
    this.systemOverlayStyle,
    this.backgroundColor,
    this.bottomLine,
  });

  bool showBackButton;
  VoidCallback? onBackButtonPressed;
  Widget? centerWidget;
  String? title;
  TextStyle? titleTextStyle;
  String? subtitle;
  TextStyle? subTitleTextStyle;
  List<ChatUIKitAppBarAction>? leadingActions;
  ChatUIKitAppBarActionsBuilder? leadingActionsBuilder;
  List<ChatUIKitAppBarAction>? trailingActions;
  ChatUIKitAppBarActionsBuilder? trailingActionsBuilder;
  bool centerTitle;
  Color? backgroundColor;
  SystemUiOverlayStyle? systemOverlayStyle;
  bool? bottomLine;
}

class ChatUIKitAppBar extends StatefulWidget implements PreferredSizeWidget {
  factory ChatUIKitAppBar.model(ChatUIKitAppBarModel model) {
    return ChatUIKitAppBar(
      title: model.title,
      centerWidget: model.centerWidget,
      titleTextStyle: model.titleTextStyle,
      subtitle: model.subtitle,
      subTitleTextStyle: model.subTitleTextStyle,
      leading: null,
      leadingActions: model.leadingActions,
      trailingActions: model.trailingActions,
      showBackButton: model.showBackButton,
      onBackButtonPressed: model.onBackButtonPressed,
      centerTitle: model.centerTitle,
      systemOverlayStyle: model.systemOverlayStyle,
      backgroundColor: model.backgroundColor,
      bottomLine: model.bottomLine ?? false,
    );
  }

  const ChatUIKitAppBar({
    this.centerWidget,
    this.title,
    this.titleTextStyle,
    this.subtitle,
    this.subTitleTextStyle,
    this.leading,
    this.leadingActions,
    this.trailingActions,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.centerTitle = false,
    this.systemOverlayStyle,
    this.backgroundColor,
    this.bottomLine = false,
    super.key,
  });

  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final Widget? centerWidget;
  final String? title;
  final TextStyle? titleTextStyle;
  final String? subtitle;
  final TextStyle? subTitleTextStyle;
  final Widget? leading;
  final List<ChatUIKitAppBarAction>? leadingActions;
  final List<ChatUIKitAppBarAction>? trailingActions;
  final bool centerTitle;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool bottomLine;

  @override
  State<ChatUIKitAppBar> createState() => _ChatUIKitAppBarState();

  @override
  Size get preferredSize {
    return const Size.fromHeight(56);
  }
}

class _ChatUIKitAppBarState extends State<ChatUIKitAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Color backgroundColor = widget.backgroundColor ??
        (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98);

    Widget? title;
    if (widget.title?.isNotEmpty == true) {
      title = Text(
        widget.title!,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.end,
        textScaler: TextScaler.noScaling,
        style: widget.titleTextStyle ??
            TextStyle(
              fontSize: theme.font.titleMedium.fontSize,
              fontWeight: theme.font.titleMedium.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
            ),
      );
    }

    Widget? subTitle;
    if (widget.subtitle?.isNotEmpty == true) {
      subTitle = Text(
        widget.subtitle!,
        textScaler: TextScaler.noScaling,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: widget.subTitleTextStyle ??
            TextStyle(
              fontSize: theme.font.bodyExtraSmall.fontSize,
              fontWeight: theme.font.bodyExtraSmall.fontWeight,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            ),
      );
    }

    Widget middle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: widget.centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        title ?? const SizedBox(),
        subTitle ?? const SizedBox(),
      ],
    );

    middle = widget.centerWidget ?? middle;

    List<Widget> leadingWidgets = [];
    if (widget.showBackButton) {
      leadingWidgets.add(
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (widget.onBackButtonPressed != null) {
              widget.onBackButtonPressed?.call();
            } else {
              Navigator.maybePop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
              bottom: 12,
              right: 2,
            ),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: theme.color.isDark
                    ? theme.color.neutralColor95
                    : theme.color.neutralColor3,
              ),
            ),
          ),
        ),
      );
    }

    List<ChatUIKitAppBarAction>? leadingActions = widget.leadingActions;
    if (leadingActions?.isNotEmpty == true) {
      leadingWidgets.addAll(
        leadingActions!.map((e) {
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => e.onTap?.call(context),
            child: Container(
              padding: EdgeInsets.only(
                  left: widget.showBackButton ? 0 : 16, right: 8),
              child: e.child,
            ),
          );
        }).toList(),
      );
    }
    Widget? leading;
    if (leadingWidgets.isNotEmpty) {
      leading = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: leadingWidgets,
      );
    }

    List<ChatUIKitAppBarAction>? trailingActions = widget.trailingActions;
    Widget? trailing;
    if (trailingActions?.isNotEmpty == true) {
      trailing = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: trailingActions!.map((e) {
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => e.onTap?.call(context),
            child: Container(
              padding: const EdgeInsets.only(left: 8),
              child: e.child,
            ),
          );
        }).toList(),
      );
      trailing = Padding(
        padding: const EdgeInsets.only(right: 8),
        child: trailing,
      );
    }

    Widget content = NavigationToolbar(
      leading: leading,
      middle: middle,
      trailing: trailing,
      centerMiddle: widget.centerTitle,
      middleSpacing: 0,
    );

    content = SafeArea(
      bottom: false,
      child: content,
    );

    content = Container(
      height: MediaQuery.paddingOf(context).top +
          widget.preferredSize.height -
          (widget.bottomLine ? 1 : 0),
      color: backgroundColor,
      child: content,
    );

    if (widget.bottomLine) {
      content = Column(
        children: [
          content,
          Divider(
            height: 1,
            thickness: 1,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          )
        ],
      );
    }

    return updateStatusBar(content, backgroundColor);
  }

  Widget updateStatusBar(Widget content, Color backgroundColor) {
    final ThemeData theme = Theme.of(context);
    final SystemUiOverlayStyle overlayStyle = _systemOverlayStyleForBrightness(
      ThemeData.estimateBrightnessForColor(backgroundColor),
      theme.useMaterial3 ? const Color(0x00000000) : null,
    );

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: backgroundColor,
          child: Semantics(
            explicitChildNodes: true,
            child: content,
          ),
        ),
      ),
    );
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness,
      [Color? backgroundColor]) {
    final SystemUiOverlayStyle style = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarBrightness: style.statusBarBrightness,
      statusBarIconBrightness: style.statusBarIconBrightness,
      systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
    );
  }
}
