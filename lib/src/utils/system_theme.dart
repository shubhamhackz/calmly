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

  static themeToString(themeSetting) {
    var selectedTheme;
    if (themeSetting == ThemeSetting.system) {
      selectedTheme = 'system';
    } else if (themeSetting == ThemeSetting.light) {
      selectedTheme = 'light';
    } else if (themeSetting == ThemeSetting.dark) {
      selectedTheme = 'dark';
    }
    return selectedTheme;
  }

  static stringToTheme(theme) {
    var selectedTheme;
    if (theme == 'system') {
      selectedTheme = ThemeSetting.system;
    } else if (theme == 'light') {
      selectedTheme = ThemeSetting.light;
    } else if (theme == 'dark') {
      selectedTheme = ThemeSetting.dark;
    }
    return selectedTheme;
  }
}
