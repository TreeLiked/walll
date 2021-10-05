class CustomNumberUtil {
  static String calCount(int count) {
    if (count < 1000) {
      return "$count";
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
