import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isModernBox = false;
  bool _isDarkMode = false;
  bool _isVibrateOn = true;

  updateTheme(bool isDarkMode) {
    this._isDarkMode = isDarkMode;
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

  get isDarkMode => _isDarkMode;

  get isModernBox => _isModernBox;

  get isVibrationOn => _isVibrateOn;
}
