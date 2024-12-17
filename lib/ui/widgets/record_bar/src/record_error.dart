class RecordError extends Error {
  RecordError(this.code, this.message);
  final int code;
  final String? message;
}
