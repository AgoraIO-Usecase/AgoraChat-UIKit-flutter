library chat_uikit_record_bar;

import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
export 'src/record_bar.dart';
export 'src/record_types.dart';
export 'src/error_code.dart';
export 'src/record_error.dart';
export 'src/record_data.dart';

Future<RecordResultData?> showChatUIKitRecordBar<T>({
  required BuildContext context,
  RecordBarController? controller,
  RecordBarOnRecord? onRecordTypeChanged,
  Color? backgroundColor,
  Color? barrierColor,
  int maxDuration = 60,
  int minDuration = 1,
}) {
  return showModalBottomSheet(
    useSafeArea: false,
    transitionAnimationController: AnimationController(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 150),
      debugLabel: 'BottomSheet',
      vsync: Navigator.of(context),
    ),
    enableDrag: false,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    context: context,
    builder: (BuildContext context) {
      AudioEncoder encoder = AudioEncoder.aacLc;
      if (ChatUIKitSettings.audioEncoder == ChatRecordEncodeType.amrNb) {
        encoder = AudioEncoder.amrNb;
      } else if (ChatUIKitSettings.audioEncoder == ChatRecordEncodeType.wav) {
        encoder = AudioEncoder.wav;
      }
      RecordBarController controller = RecordBarController(
        recordConfig: RecordConfig(
          encoder: encoder,
          numChannels: 1,
          bitRate: 128000,
          sampleRate: 44100,
        ),
      );
      return RecordBar(
        controller: controller,
        maxDuration: maxDuration,
        minDuration: minDuration,
        onRecordTypeChanged: onRecordTypeChanged,
        onRecordFinished: (data) {
          Navigator.of(context).pop(data);
        },
      );
    },
  );
}
