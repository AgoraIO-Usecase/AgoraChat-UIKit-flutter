class RecordResultData {
  final String? path;
  final String? fileName;
  final int? duration;

  RecordResultData({
    this.path,
    this.fileName,
    this.duration,
  });

  RecordResultData copyWith({
    String? path,
    String? fileName,
    int? duration,
  }) {
    return RecordResultData(
      path: path ?? this.path,
      fileName: fileName ?? this.fileName,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'RecordResultData(path: $path, fileName: $fileName, duration: $duration)';
  }
}
