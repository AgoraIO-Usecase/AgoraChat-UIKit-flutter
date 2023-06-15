import 'package:common_utils/common_utils.dart';

class TimeTool {
  static String timeStrByMs(int ms, {bool showTime = false}) {
    String ret = '';
    // 是否当天
    // HH:mm
    if (DateUtil.isToday(ms)) {
      ret = DateUtil.formatDateMs(ms, format: 'HH:mm');
    }
    // // 是否本周
    // // 周一、周二、周三...
    // else if (DateUtil.isWeek(ms)) {
    //   ret = DateUtil.getWeekdayByMs(ms);
    // }

    // 是否本年
    // MM/dd
    else if (DateUtil.yearIsEqualByMs(ms, DateUtil.getNowDateMs())) {
      if (showTime) {
        ret = DateUtil.formatDateMs(ms, format: 'MM/dd HH:mm');
      } else {
        ret = DateUtil.formatDateMs(ms, format: 'MM/dd');
      }
    }
    // yyyy/MM/dd
    else {
      if (showTime) {
        ret = DateUtil.formatDateMs(ms, format: 'yyyy/MM/dd HH:mm');
      } else {
        ret = DateUtil.formatDateMs(ms, format: 'yyyy/MM/dd');
      }
    }

    return ret;
  }

  static String durationStr(int duration) {
    if (duration <= 60) {
      return "${duration.toInt()}\"";
    } else if (duration > 60 && duration < 3600) {
      return "${(duration / 60).truncate().toInt()}'${(duration % 60).toInt()}\"";
    } else {
      return "${(duration / 3600).truncate().toInt()}h${(duration % 3600 / 60).truncate().toInt()}'${(duration % 3600 % 60).truncate().toInt()}\"";
    }
  }
}
