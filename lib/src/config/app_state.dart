import 'package:flutter/material.dart';
import 'package:calmly/src/constants/constants.dart';
import 'package:calmly/src/utils/local_db.dart';

class AppState extends ChangeNotifier {
  bool _isModernBox = true;
  bool _isVibrateOn;
  ThemeSetting _themeSetting;
  LocalDB _localDB;

  AppState() {
    _localDB = LocalDB();
    _isVibrateOn = _localDB.getVibrationSettings ?? true;
    _isModernBox = _localDB.getBoxTypeSettings ?? true;
    _themeSetting = _localDB.getThemeSettings ?? ThemeSetting.light;
  }

  updateTheme(ThemeSetting themeSetting) {
    this._themeSetting = themeSetting;
    _localDB.saveThemeSettings(themeSetting);
    notifyListeners();
  }

  updateBox(bool isModernBox) {
    this._isModernBox = isModernBox;
    _localDB.saveBoxTypeSettings(isModernBox);
    notifyListeners();
  }

  updateVibration(bool isVibrationOn) {
    this._isVibrateOn = isVibrationOn;
    _localDB.saveVibrationSettings(isVibrationOn);
    notifyListeners();
  }

  get themeSetting => _themeSetting;

  get isModernBox => _isModernBox;

  get isVibrationOn => _isVibrateOn;
}
