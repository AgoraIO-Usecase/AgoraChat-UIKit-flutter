import 'record_data.dart';

enum RecordBarRecordType {
  idle,
  recording,
  recorded,
  playing,
}

typedef RecordBarOnRecord = void Function(RecordBarRecordType type);
typedef RecordBarOnRecordFinished = void Function(RecordResultData data);
