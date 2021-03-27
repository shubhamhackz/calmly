import 'package:flutter/material.dart';
import 'package:calmly/src/constants/constants.dart';

class AppState extends ChangeNotifier {
  bool _isModernBox = true;
  bool _isVibrateOn = true;
  ThemeSetting _themeSetting = ThemeSetting.light;

  updateTheme(ThemeSetting themeSetting) {
    this._themeSetting = themeSetting;
    notifyListeners();
  }

  updateBox(bool isModernBox) {
    this._isModernBox = isModernBox;
    notifyListeners();
  }

  updateVibration(bool isVibrationOn) {
    this._isVibrateOn = isVibrationOn;
    notifyListeners();
  }

  get themeSetting => _themeSetting;

  get isModernBox => _isModernBox;

  get isVibrationOn => _isVibrateOn;
}
