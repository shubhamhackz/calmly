import 'package:calmly/src/config/theme_config.dart';
import 'package:calmly/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config/app_state.dart';
import 'constants/constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ); //change statusbar cxolor
    return Consumer<AppState>(
      builder: (_, appState, __) {
        if (appState.themeSetting == ThemeSetting.system) {
          var brightness = SchedulerBinding.instance.window.platformBrightness;
          bool darkModeOn = brightness == Brightness.dark;
          if (darkModeOn) {
            appState.updateTheme(ThemeSetting.dark);
          } else {
            appState.updateTheme(ThemeSetting.light);
          }
        }
        return MaterialApp(
          title: 'Flutter Demo',
          theme: appState.themeSetting == ThemeSetting.light
              ? ThemeConfig.lightTheme
              : ThemeConfig.darkTheme,
          home: HomeScreen(),
        );
      },
    );
  }
}
