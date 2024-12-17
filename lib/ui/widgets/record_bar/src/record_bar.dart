import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../chat_uikit.dart';

import 'water_ripple.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class RecordBarController {
  final RecordConfig recordConfig;
  late final AudioRecorder record;
  late final AudioPlayer player;
  String? currentPath;
  RecordBarState? _state;
  Directory? _directory;
  String? fileName;
  RecordBarController({
    this.recordConfig = const RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
      numChannels: 1,
    ),
  }) {
    getTemporaryDirectory().then((value) => _directory = value);
    record = AudioRecorder();
    record
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((event) {
      onAmplitudeChanged?.call(event.current, event.max);
    });

    player = AudioPlayer();
  }

  void Function(
    double currentAmplitude,
    double maxAmplitude,
  )? onAmplitudeChanged;

  void attach(RecordBarState state) {
    _state = state;
  }

  void detach() {
    _state = null;
  }

  void dispose() {
    _state = null;
    player.release();
    record.dispose();
  }

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      if (await record.isRecording()) {
        return;
      }
      try {
        fileName =
            "${DateTime.now().millisecondsSinceEpoch.toString()}.$extensionName";
        record.start(recordConfig, path: "${_directory!.path}/$fileName");
        _state?.switchRecordType(RecordBarRecordType.recording);
      } catch (e) {
        throw RecordError(recordFailed, 'Failed to start recording');
      }
    } else {
      throw RecordError(permissionDenied, 'Permission denied');
    }
  }

  Future<String?> finishRecording() async {
    if (await record.isRecording()) {
      String? path = await record.stop();
      _state?.switchRecordType(RecordBarRecordType.recorded);
      currentPath = path;
      return path;
    }
    _state?.switchRecordType(RecordBarRecordType.idle);
    return null;
  }

  Future<void> stopRecording() async {
    if (await record.isRecording()) {
      String? path = await record.stop();
      if (path != null) {
        File file = File(path);
        file.delete();
      }
    }
    _state?.switchRecordType(RecordBarRecordType.idle);
  }

  Future<void> startPlaying() async {
    if (currentPath == null) {
      _state?.switchRecordType(RecordBarRecordType.idle);
      return;
    }
    await player.play(DeviceFileSource(currentPath!));
    _state?.switchRecordType(RecordBarRecordType.playing);
  }

  Future<void> stopPlaying() async {
    await player.stop();
    _state?.switchRecordType(RecordBarRecordType.recorded);
  }

  Future<RecordResultData> send() async {
    String? path;
    if (await record.isRecording()) {
      path = await record.stop();
      _state?.switchRecordType(RecordBarRecordType.idle);
    } else {
      path = currentPath;
      currentPath = null;
      _state?.switchRecordType(RecordBarRecordType.idle);
    }
    return RecordResultData(path: path, fileName: fileName);
  }

  void reset() {
    currentPath = null;
  }

  String get extensionName {
    switch (recordConfig.encoder) {
      case AudioEncoder.aacLc:
      case AudioEncoder.aacEld:
      case AudioEncoder.aacHe:
        return 'm4a';
      case AudioEncoder.amrNb:
      case AudioEncoder.amrWb:
        return '3gp';
      case AudioEncoder.opus:
        return 'opus';
      case AudioEncoder.flac:
        return 'flac';
      case AudioEncoder.wav:
        return 'wav';
      case AudioEncoder.pcm16bits:
        return 'pcm';
      default:
        return '';
    }
  }
}

class RecordBar extends StatefulWidget {
  const RecordBar({
    this.controller,
    this.onRecordTypeChanged,
    this.onRecordFinished,
    this.maxDuration = 60,
    this.minDuration = 1,
    super.key,
  });
  final RecordBarOnRecord? onRecordTypeChanged;
  final RecordBarOnRecordFinished? onRecordFinished;
  final RecordBarController? controller;
  final int maxDuration;
  final int minDuration;

  @override
  State<RecordBar> createState() => RecordBarState();
}

class RecordBarState extends State<RecordBar> with ChatUIKitThemeMixin {
  int recordCounter = 0;
  int playCounter = 0;
  Timer? timer;
  RecordBarRecordType recordType = RecordBarRecordType.idle;
  late final RecordBarController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? RecordBarController();
    setup();
  }

  setup() {
    controller.attach(this);
  }

  void switchRecordType(RecordBarRecordType type) {
    recordType = type;
    widget.onRecordTypeChanged?.call(type);
    switch (type) {
      case RecordBarRecordType.idle:
        stopRecordTimer();
        stopPlayTimer();
        break;
      case RecordBarRecordType.recording:
        startRecordTimer();
        break;
      case RecordBarRecordType.recorded:
        stopRecordTimer();
        break;
      case RecordBarRecordType.playing:
        startPlayTimer();
        break;
    }
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        borderRadius: const BorderRadius.only(
            // topLeft: Radius.circular(4),
            // topRight: Radius.circular(4),
            ),
      ),
      height: 200,
      child: Column(
        children: [actionsWidget()],
      ),
    );

    content = SafeArea(child: content);

    return content;
  }

  Widget actionsWidget() {
    return Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (recordType != RecordBarRecordType.idle)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    controller.stopRecording();
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.color.isDark
                          ? theme.color.neutralColor2
                          : theme.color.neutralColor9,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: ChatUIKitImageLoader.voiceDelete(
                        width: 20,
                        height: 20,
                        color: theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor5,
                      ),
                    ),
                  ),
                ),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  if (recordType == RecordBarRecordType.idle) {
                    controller.startRecording();
                  } else if (recordType == RecordBarRecordType.recording) {
                    if (recordCounter < widget.minDuration) {
                      controller.stopRecording();
                    } else {
                      controller.finishRecording();
                    }
                  } else if (recordType == RecordBarRecordType.recorded) {
                    await controller.startPlaying();
                  } else if (recordType == RecordBarRecordType.playing) {
                    await controller.stopPlaying();
                  }
                },
                child: WaterRipper(
                  color: theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5,
                  duration: const Duration(milliseconds: 1500),
                  count: 7,
                  enable: recordType == RecordBarRecordType.recording ||
                      recordType == RecordBarRecordType.playing,
                  child: Container(
                    width: 72,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: () {
                        if (recordType == RecordBarRecordType.idle) {
                          return ChatUIKitImageLoader.voiceMic(
                            width: 24,
                            height: 24,
                            color: theme.color.neutralColor98,
                          );
                        } else if (recordType == RecordBarRecordType.recorded ||
                            recordType == RecordBarRecordType.recording) {
                          return Text(
                            '${recordCounter}s',
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.color.isDark
                                    ? theme.color.neutralColor98
                                    : theme.color.neutralColor98,
                                fontWeight: theme.font.headlineSmall.fontWeight,
                                fontSize: theme.font.headlineSmall.fontSize),
                          );
                        } else if (recordType == RecordBarRecordType.playing) {
                          return Text(
                            '${playCounter}s',
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: theme.color.isDark
                                    ? theme.color.neutralColor98
                                    : theme.color.neutralColor98,
                                fontWeight: theme.font.headlineSmall.fontWeight,
                                fontSize: theme.font.headlineSmall.fontSize),
                          );
                        }
                        return const SizedBox();
                      }(),
                    ),
                  ),
                ),
              ),
              if (recordType != RecordBarRecordType.idle)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    if (recordCounter < widget.minDuration) {
                      controller.stopRecording();
                    } else {
                      RecordResultData data = await controller.send();
                      data = data.copyWith(
                        duration: recordCounter,
                      );
                      widget.onRecordFinished?.call(data);
                      controller.reset();
                    }
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: ChatUIKitImageLoader.voiceSend(
                        width: 20,
                        height: 20,
                        color: theme.color.isDark
                            ? theme.color.neutralColor98
                            : theme.color.neutralColor98,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          recordType == RecordBarRecordType.idle
              ? ChatUIKitLocal.recordBarRecord.localString(context)
              : recordType == RecordBarRecordType.recording
                  ? ChatUIKitLocal.recordBarRecording.localString(context)
                  : recordType == RecordBarRecordType.recorded
                      ? ChatUIKitLocal.recordBarPlay.localString(context)
                      : ChatUIKitLocal.recordBarPlaying.localString(context),
          textScaler: TextScaler.noScaling,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor7
                  : theme.color.neutralColor5,
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize),
        ),
        const SizedBox(height: 8),
        if (widget.maxDuration - recordCounter < 10 &&
            recordType == RecordBarRecordType.recording)
          Text(
            context.formatString(ChatUIKitLocal.recordBarAutoStop,
                ['${widget.maxDuration - recordCounter}']),
            textScaler: TextScaler.noScaling,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor7
                    : theme.color.neutralColor5,
                fontWeight: theme.font.labelMedium.fontWeight,
                fontSize: theme.font.labelMedium.fontSize),
          ),
      ],
    );
  }

  void startRecordTimer() {
    playCounter = 0;
    recordCounter = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordCounter++;
      if (recordCounter >= widget.maxDuration) {
        controller.finishRecording();
        timer.cancel();
      }
      setState(() {});
    });
  }

  void stopRecordTimer() {
    timer?.cancel();
  }

  void startPlayTimer() {
    playCounter = 0;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      playCounter++;
      if (playCounter >= recordCounter) {
        controller.stopPlaying();
        timer.cancel();
      }
      setState(() {});
    });
  }

  void stopPlayTimer() {
    timer?.cancel();
  }

  Widget playButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.primaryColor6
            : theme.color.primaryColor5,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: ChatUIKitImageLoader.voiceSend(
          width: 20,
          height: 20,
          color: theme.color.neutralColor98,
        ),
      ),
    );
  }
}
