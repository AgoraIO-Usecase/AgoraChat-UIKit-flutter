import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ChangeInfoView extends StatefulWidget {
  ChangeInfoView.arguments(ChangeInfoViewArguments arguments, {super.key})
      : hint = arguments.hint,
        inputTextCallback = arguments.inputTextCallback,
        saveButtonTitle = arguments.saveButtonTitle,
        maxLength = arguments.maxLength,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        attributes = arguments.attributes;

  const ChangeInfoView({
    this.hint,
    this.inputTextCallback,
    this.saveButtonTitle,
    this.maxLength = 128,
    this.appBarModel,
    this.enableAppBar = true,
    this.attributes,
    super.key,
  });

  final String? hint;
  final String? saveButtonTitle;
  final int maxLength;
  final ChatUIKitAppBarModel? appBarModel;
  final Future<String?> Function()? inputTextCallback;
  final bool enableAppBar;
  final String? attributes;

  @override
  State<ChangeInfoView> createState() => _ChangeInfoViewState();
}

class _ChangeInfoViewState extends State<ChangeInfoView>
    with ChatUIKitThemeMixin {
  final TextEditingController controller = TextEditingController();

  String? originalStr;

  ValueNotifier<bool> isChanged = ValueNotifier<bool>(false);

  ChatUIKitAppBarModel? appBarModel;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      controller.text != originalStr
          ? isChanged.value = true
          : isChanged.value = false;
    });

    widget.inputTextCallback?.call().then((value) {
      originalStr = value ?? '';
      controller.text = value ?? '';
    });
  }

  updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title,
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: widget.appBarModel?.trailingActions ??
          () {
            List<ChatUIKitAppBarAction> actions = [
              ChatUIKitAppBarAction(
                actionType: ChatUIKitActionType.save,
                onTap: (context) {
                  if (isChanged.value) {
                    Navigator.of(context).pop(controller.text);
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: isChanged,
                  builder: (context, value, child) {
                    return Text(
                      widget.saveButtonTitle ??
                          ChatUIKitLocal.changInfoViewSave.localString(context),
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: theme.font.labelMedium.fontWeight,
                        fontSize: theme.font.labelMedium.fontSize,
                        color: value
                            ? (theme.color.isDark
                                ? theme.color.primaryColor6
                                : theme.color.primaryColor5)
                            : (theme.color.isDark
                                ? theme.color.neutralColor5
                                : theme.color.neutralColor6),
                      ),
                    );
                  },
                ),
              )
            ];
            return widget.appBarModel?.trailingActionsBuilder
                    ?.call(context, actions) ??
                actions;
          }(),
      showBackButton: widget.appBarModel?.showBackButton ?? true,
      onBackButtonPressed: widget.appBarModel?.onBackButtonPressed,
      centerTitle: widget.appBarModel?.centerTitle ?? false,
      systemOverlayStyle: widget.appBarModel?.systemOverlayStyle,
      backgroundColor: widget.appBarModel?.backgroundColor ??
          (theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98),
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    updateAppBarModel(theme);
    Widget content = Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor95,
          ),
          child: TextField(
            keyboardAppearance:
                theme.color.isDark ? Brightness.dark : Brightness.light,
            maxLines: 4,
            minLines: 1,
            buildCounter: (
              context, {
              required int currentLength,
              required int? maxLength,
              required bool isFocused,
            }) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      "$currentLength/$maxLength",
                      overflow: TextOverflow.ellipsis,
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                          color: theme.color.isDark
                              ? theme.color.neutralColor5
                              : theme.color.neutralColor7),
                    )),
              );
            },
            maxLength: widget.maxLength,
            controller: controller,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor98
                  : theme.color.neutralColor1,
            ),
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: widget.hint ??
                  ChatUIKitLocal.changInfoViewInputHint.localString(context),
              hintStyle: TextStyle(
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor5
                    : theme.color.neutralColor7,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
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
}
