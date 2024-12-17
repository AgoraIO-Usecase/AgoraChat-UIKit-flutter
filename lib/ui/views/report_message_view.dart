import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ReportMessageView extends StatefulWidget {
  ReportMessageView.arguments(
    ReportMessageViewArguments arguments, {
    super.key,
  })  : messageId = arguments.messageId,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        reportReasons = arguments.reportReasons,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const ReportMessageView({
    required this.messageId,
    required this.reportReasons,
    this.appBarModel,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    super.key,
  });
  final ChatUIKitAppBarModel? appBarModel;
  final String messageId;
  final List<String> reportReasons;
  final bool enableAppBar;

  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ReportMessageView> createState() => _ReportMessageViewState();
}

class _ReportMessageViewState extends State<ReportMessageView>
    with ChatUIKitThemeMixin {
  int selectedIndex = -1;
  ChatUIKitAppBarModel? appBarModel;
  final scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  dispose() {
    widget.viewObserver?.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title ??
          ChatUIKitLocal.reportMessageViewTitle.localString(context),
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: widget.appBarModel?.trailingActions ??
          widget.appBarModel?.trailingActionsBuilder?.call(context, null),
      showBackButton: widget.appBarModel?.showBackButton ?? true,
      onBackButtonPressed: widget.appBarModel?.onBackButtonPressed,
      centerTitle: widget.appBarModel?.centerTitle ?? false,
      systemOverlayStyle: widget.appBarModel?.systemOverlayStyle,
      backgroundColor: widget.appBarModel?.backgroundColor,
      bottomLine: widget.appBarModel?.bottomLine,
      bottomLineColor: widget.appBarModel?.bottomLineColor,
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    updateAppBarModel(theme);
    Widget content = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text(
                ChatUIKitLocal.reportMessageViewReportReasons
                    .localString(context),
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.noScaling,
                maxLines: 1,
                style: TextStyle(
                    fontWeight: theme.font.titleSmall.fontWeight,
                    fontSize: theme.font.titleSmall.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5)),
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child:
                    tile(widget.reportReasons[index], selectedIndex == index),
              );
            },
            childCount: widget.reportReasons.length,
          ),
        ),
      ],
    );

    content = Column(
      children: [
        Expanded(child: content),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ChatUIKitButton.neutral(
                  ChatUIKitLocal.reportMessageViewCancel.localString(context),
                  radius: 4,
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChatUIKitButton.primary(
                  ChatUIKitLocal.reportMessageViewConfirm.localString(context),
                  radius: 4,
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
                  onTap: () {
                    if (selectedIndex == -1) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context)
                          .pop(widget.reportReasons[selectedIndex]);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: content,
    );

    content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: SafeArea(child: content),
    );

    return content;
  }

  Widget tile(String title, bool selected) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          Text(
            title,
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: (theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1)),
          ),
          Expanded(child: Container()),
          selected
              ? Icon(Icons.radio_button_checked,
                  size: 21.33,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor6
                      : theme.color.primaryColor5))
              : Icon(Icons.radio_button_unchecked,
                  size: 21.33,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor8
                      : theme.color.neutralColor7))
        ],
      ),
    );
  }
}
