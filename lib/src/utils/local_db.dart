import 'package:calmly/src/constants/constants.dart';
import 'package:calmly/src/utils/system_theme.dart';
import 'package:hive/hive.dart';

class LocalDB {
  var box;
  LocalDB._internal();

  static final LocalDB _localDB = LocalDB._internal();

  factory LocalDB() {
    return _localDB;
  }

  init() async {
    box = await Hive.openBox('calmly');
  }

  saveThemeSettings(ThemeSetting themeSetting) {
    box.put('themeSetting', SystemTheme.themeToString(themeSetting));
  }

  saveVibrationSettings(bool isVibrationOn) {
    box.put('isVibrationOn', isVibrationOn);
  }

  saveBoxTypeSettings(bool isTraditional) {
    box.put('isTraditional', isTraditional);
  }

  saveTotalCalmly(int count) {
    box.put('totalCalmly', count);
  }

  get getVibrationSettings => box.get('isVibrationOn');

  get getBoxTypeSettings => box.get('isTraditional');

  get getThemeSettings {
    return SystemTheme.stringToTheme(box.get('themeSetting'));
  }

  get getTotalCalmly => box.get('totalCalmly');
}
