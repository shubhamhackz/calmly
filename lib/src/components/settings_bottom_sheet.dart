import 'package:calmly/src/utils/system_theme.dart';
import 'package:flutter/material.dart';

import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/constants/constants.dart';

import 'package:provider/provider.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  _SettingsBottomSheetState createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  AppState _appState;
  ThemeSetting _theme;
  bool isDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = Provider.of<AppState>(context);
    _theme = _appState.themeSetting;
    isDark = SystemTheme.isDark(_appState);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.025, horizontal: width * 0.05),
      width: width,
      height: height * 0.3,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 18,
          color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rock the 80s theme'),
                  Switch(
                    value: !_appState.isModernBox,
                    onChanged: (value) {
                      setState(() {
                        _appState.updateBox(!_appState.isModernBox);
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Dialog(
                              child: Container(
                                height: height * 0.275,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        right: width * 0.075,
                                        left: width * 0.075,
                                        bottom: height * 0.0075,
                                        top: height * 0.025,
                                      ),
                                      child: Text(
                                        'Select Theme',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    RadioListTile<ThemeSetting>(
                                      onChanged: (ThemeSetting theme) {
                                        setState(() {
                                          _theme = theme;
                                          _appState
                                              .updateTheme(ThemeSetting.system);
                                        });
                                      },
                                      value: ThemeSetting.system,
                                      groupValue: _theme,
                                      title: Text('System Default'),
                                    ),
                                    RadioListTile<ThemeSetting>(
                                      onChanged: (ThemeSetting theme) {
                                        setState(() {
                                          _appState
                                              .updateTheme(ThemeSetting.dark);
                                          _theme = theme;
                                        });
                                      },
                                      value: ThemeSetting.dark,
                                      groupValue: _theme,
                                      title: Text('Dark'),
                                    ),
                                    RadioListTile<ThemeSetting>(
                                      onChanged: (ThemeSetting theme) {
                                        setState(() {
                                          _theme = theme;
                                          _appState
                                              .updateTheme(ThemeSetting.light);
                                        });
                                      },
                                      value: ThemeSetting.light,
                                      groupValue: _theme,
                                      title: Text('Light'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      });
                },
                child: Builder(
                  builder: (_) {
                    ThemeSetting themeSetting = _appState.themeSetting;
                    return Container(
                      height: height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (themeSetting == ThemeSetting.system)
                            Text('System')
                          else if (themeSetting == ThemeSetting.dark)
                            Text('Dark')
                          else if (themeSetting == ThemeSetting.light)
                            Text('Light')
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vibration'),
                  Switch(
                    value: _appState.isVibrationOn,
                    onChanged: (value) {
                      setState(() {
                        _appState.updateVibration(!_appState.isVibrationOn);
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerLeft, child: Text('About'))),
          ],
        ),
      ),
    );
  }
}
