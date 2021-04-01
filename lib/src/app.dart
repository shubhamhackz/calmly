import 'package:calmly/src/config/theme_config.dart';
import 'package:calmly/src/screens/home_screen.dart';

import 'package:calmly/src/utils/system_theme.dart';
import 'package:calmly/src/config/device_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_state.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //initialize width and height
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Consumer<AppState>(
      builder: (_, appState, __) {
        //change statusbar cxolor
        SystemTheme.changeStatusBarColor(appState);
        return MaterialApp(
          title: 'Flutter Demo',
          theme: SystemTheme.isDark(appState)
              ? ThemeConfig.darkTheme
              : ThemeConfig.lightTheme,
          home: HomeScreen(),
        );
      },
    );
  }
}
