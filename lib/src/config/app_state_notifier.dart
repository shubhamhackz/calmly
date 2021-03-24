import 'package:flutter/material.dart';

class AppStateNotifier extends ChangeNotifier {
  bool isModernBox;
  bool isDarkMode;
  bool isVibrateOn;

  AppStateNotifier({
    this.isDarkMode = false,
    this.isModernBox = false,
    this.isVibrateOn = true,
  });

  updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }

  updateBox(bool isModernBox) {
    this.isModernBox = isModernBox;
    notifyListeners();
  }

  updateVibration(bool isVibrationOn) {
    this.isVibrateOn = isVibrationOn;
    notifyListeners();
  }
}
