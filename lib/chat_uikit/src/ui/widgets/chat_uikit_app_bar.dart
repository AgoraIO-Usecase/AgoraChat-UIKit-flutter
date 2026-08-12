import 'package:flutter/semantics.dart';

import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatUIKitAppBarModel {
  /// ChatUIKitAppBarModel 构造函数
  /// [title] 标题
  /// [centerWidget] 中间控件, 优先级高于title 和 subtitle，如果设置了centerWidget，title 和 subtitle 将不会显示
  /// [titleTextStyle] 标题样式
  /// [subtitle] 副标题
  /// [subTitleTextStyle] 副标题样式
  /// [leadingActions] 左侧控件
  /// [leadingActionsBuilder] 左侧控件构建器, 当存在默认值时会回调。
  /// [trailingActions] 右侧控件
  /// [trailingActionsBuilder] 右侧控件构建器, 当存在默认值时会回调。
  /// [showBackButton] 是否显示返回键
  /// [onBackButtonPressed] 返回键点击事件, 不设置是默认为返回上一页
  /// [centerTitle] 是否居中显示标题
  /// [systemOverlayStyle] 状态栏样式
  /// [backgroundColor] 状态栏样式
  /// [bottomLine] 是否显示底部分割线
  /// [bottomLineColor] 底部分割线颜色
  /// [flexibleSpace] 中间控件
  /// [bottomWidgetHeight] 底部控件高度
  /// [bottomWidget] 底部控件
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
    this.bottomLineColor,
    this.flexibleSpace,
    this.bottomWidgetHeight,
    this.bottomWidget,
  });

  /// 是否显示返回键
  bool showBackButton;

  /// 返回键点击事件
  VoidCallback? onBackButtonPressed;

  /// 中间控件, 优先级高于title 和 subtitle，如果设置了centerWidget，title 和 subtitle 将不会显示
  Widget? centerWidget;

  /// 标题
  String? title;

  /// 标题样式
  TextStyle? titleTextStyle;

  /// 副标题
  String? subtitle;

  /// 副标题样式
  TextStyle? subTitleTextStyle;

  /// 左侧控件
  List<ChatUIKitAppBarAction>? leadingActions;

  /// 左侧控件构建器
  ChatUIKitAppBarActionsBuilder? leadingActionsBuilder;

  /// 右侧控件
  List<ChatUIKitAppBarAction>? trailingActions;

  /// 右侧控件构建器
  ChatUIKitAppBarActionsBuilder? trailingActionsBuilder;

  /// 是否居中显示标题
  bool centerTitle;

  /// 状态栏样式
  Color? backgroundColor;

  /// 状态栏样式
  SystemUiOverlayStyle? systemOverlayStyle;

  /// 是否显示底部分割线
  bool? bottomLine;

  /// 底部分割线颜色
  Color? bottomLineColor;

  Widget? flexibleSpace;

  double? bottomWidgetHeight;

  Widget? bottomWidget;
}

const appBarHeight = 52.0;

class ChatUIKitAppBar extends StatefulWidget implements PreferredSizeWidget {
  factory ChatUIKitAppBar.model(ChatUIKitAppBarModel model) {
    return ChatUIKitAppBar(
      title: model.title,
      centerWidget: model.centerWidget,
      titleTextStyle: model.titleTextStyle,
      subtitle: model.subtitle,
      subTitleTextStyle: model.subTitleTextStyle,
      leadingActions: model.leadingActions,
      trailingActions: model.trailingActions,
      showBackButton: model.showBackButton,
      onBackButtonPressed: model.onBackButtonPressed,
      centerTitle: model.centerTitle,
      systemOverlayStyle: model.systemOverlayStyle,
      backgroundColor: model.backgroundColor,
      bottomLine: model.bottomLine ?? true,
      bottomLineColor: model.bottomLineColor,
      flexibleSpace: model.flexibleSpace,
      bottomWidgetHeight: model.bottomWidgetHeight,
      bottomWidget: model.bottomWidget,
    );
  }

  ChatUIKitAppBar({
    this.centerWidget,
    this.title,
    this.titleTextStyle,
    this.subtitle,
    this.subTitleTextStyle,
    this.leadingActions,
    this.trailingActions,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.centerTitle = false,
    this.systemOverlayStyle,
    this.backgroundColor,
    this.bottomLine = false,
    this.bottomLineColor,
    this.flexibleSpace,
    double? bottomWidgetHeight,
    this.bottomWidget,
    super.key,
  })  : preferredSize =
            Size.fromHeight(appBarHeight + (bottomWidgetHeight ?? 0)),
        bottomWidgetHeight = bottomWidgetHeight ?? 0;

  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final Widget? centerWidget;
  final String? title;
  final TextStyle? titleTextStyle;
  final String? subtitle;
  final TextStyle? subTitleTextStyle;
  final List<ChatUIKitAppBarAction>? leadingActions;
  final List<ChatUIKitAppBarAction>? trailingActions;
  final bool centerTitle;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool bottomLine;
  final Color? bottomLineColor;
  final Widget? flexibleSpace;
  final double bottomWidgetHeight;
  final Widget? bottomWidget;

  @override
  State<ChatUIKitAppBar> createState() => _ChatUIKitAppBarState();

  @override
  final Size preferredSize;
}

class _ChatUIKitAppBarState extends State<ChatUIKitAppBar>
    with ChatUIKitThemeMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
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

    List<ChatUIKitAppBarAction>? leadingActions = widget.leadingActions;
    Widget? leading;
    if (leadingActions?.isNotEmpty == true) {
      leading = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: leadingActions!.map((e) {
          return InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => e.onTap?.call(context),
            child: e.child,
          );
        }).toList(),
      );
      leading = Padding(
        padding: const EdgeInsets.only(right: 8),
        child: leading,
      );
    }
    Widget? backButton;
    if (widget.showBackButton) {
      backButton = InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.onBackButtonPressed != null) {
            widget.onBackButtonPressed?.call();
          } else {
            Navigator.maybePop(context);
          }
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8),
          margin: const EdgeInsets.only(left: 12, right: 5),
          // color: Colors.red,
          width: 20,
          height: 40,
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: theme.color.isDark
                ? theme.color.neutralColor95
                : theme.color.neutralColor3,
          ),
        ),
      );
    }
    leading = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        backButton ?? const SizedBox(),
        SizedBox(width: backButton == null ? 10 : 8),
        leading ?? const SizedBox()
      ],
    );

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
            child: e.child,
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
      alignment: Alignment.topCenter,
      height: MediaQuery.paddingOf(context).top +
          appBarHeight -
          (widget.bottomLine ? 0.3 : 0),
      color: backgroundColor,
      child: content,
    );

    content = Column(
      children: [
        content,
        Expanded(
          child: widget.bottomWidgetHeight != 0
              ? SizedBox(
                  height: widget.bottomWidgetHeight,
                  child: widget.bottomWidget,
                )
              : const SizedBox(),
        ),
        widget.bottomLine
            ? Divider(
                height: 0.3,
                thickness: 0.3,
                color: widget.bottomLineColor ??
                    (theme.color.isDark
                        ? theme.color.neutralColor2
                        : theme.color.neutralColor9),
              )
            : const SizedBox(),
      ],
    );

    if (widget.flexibleSpace != null) {
      content = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Semantics(
            sortKey: const OrdinalSortKey(1.0),
            explicitChildNodes: true,
            child: widget.flexibleSpace,
          ),
          Semantics(
            sortKey: const OrdinalSortKey(0.0),
            explicitChildNodes: true,
            // Creates a material widget to prevent the flexibleSpace from
            // obscuring the ink splashes produced by appBar children.
            child: Material(
              type: MaterialType.transparency,
              child: content,
            ),
          ),
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
