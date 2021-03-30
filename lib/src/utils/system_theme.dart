import 'dart:ui';

import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/constants/constants.dart';
import 'package:flutter/scheduler.dart';

class SystemTheme {
  static check(AppState appState) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    if (darkModeOn) {
      return ThemeSetting.dark;
    } else {
      return ThemeSetting.light;
    }
  }

  static isDark(_appState) {
    bool isDark;
    ThemeSetting themeSetting = _appState.themeSetting;
    if (themeSetting == ThemeSetting.system) {
      isDark = SystemTheme.check(_appState) == ThemeSetting.dark;
    } else if (themeSetting == ThemeSetting.light) {
      isDark = false;
    } else if (themeSetting == ThemeSetting.dark) {
      isDark = true;
    }
    return isDark;
  }
}
