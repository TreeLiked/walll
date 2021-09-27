import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';

class TimeUtil {
  static String getShortTime(DateTime dt) {
    return TimelineUtil.format(dt.millisecondsSinceEpoch, locale: "zh_normal", dayFormat: DayFormat.Full);
  }


  static String timeInDay(int hour) {
    if (hour < 6) {
      return "凌晨 ";
    } else if (hour < 12) {
      return "上午 ";
    } else if (hour < 21) {
      return "下午 ";
    } else {
      return "晚上 ";
    }
  }

  // MM月DD日
  static String MMDD(DateTime dt) {
    return DateUtil.formatDate(dt, format: DateFormats.zh_mo_d);
  }

  // HH时mm分
  static String HHmm(DateTime dt) {
    return DateUtil.formatDate(dt, format: DateFormats.zh_h_m);
  }

  static bool sameYear(DateTime dt) {
    return dt.year == DateTime.now().year;
  }

  static bool sameMonthAndYear(DateTime dt) {
    return sameYear(dt) && dt.month == DateTime.now().month;
  }

  static bool sameDayAndYearMonth(DateTime dt) {
    return sameMonthAndYear(dt) && dt.day == DateTime.now().day;
  }
}
