import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../application.dart';

class ThemeUtil {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static bool isDarkNew() {
    return isDark(Application.context!);
  }
}
