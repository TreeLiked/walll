class CustomNumberUtil {
  /// 获取返回的字符数量
  static int calStrCountForNumber(int count) {
    return calCount(count).length;
  }

  static String calCount(int count, {bool zeroEmpty = false}) {
    if (count < 100) {
      if (count == 0 && zeroEmpty) {
        return "";
      }
      return "$count";
    }
    if (count < 1000) {
      return "${count ~/ 100}00+";
    }
    if (count < 10000) {
      return "${count ~/ 1000}k+";
    }
    if (count < 100000) {
      return "${count ~/ 10000}w+";
    }
    return "10w+";
  }

  static String calCountHundred(int count) {
    if (count < 100) {
      return "< 100";
    }
    if (count < 1000) {
      return "${count ~/ 100 * 100}+";
    }
    if (count < 10000) {
      return "${count ~/ 1000}k+";
    }
    if (count < 100000) {
      return "${count ~/ 10000}w+";
    }
    return "10w+";
  }
}
