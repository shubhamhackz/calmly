import 'dart:ui';

import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/constants/constants.dart';
import 'package:flutter/scheduler.dart';

class SystemTheme {
  static check(AppState appState) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    if (darkModeOn) {
      appState.updateTheme(ThemeSetting.dark);
    } else {
      appState.updateTheme(ThemeSetting.light);
    }
  }
}
