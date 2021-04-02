import 'package:flutter/material.dart';

import 'package:calmly/src/components/calm_box/modern_calm_box.dart';
import 'package:calmly/src/components/calm_box/traditional_calm_box.dart';
import 'package:calmly/src/components/home_widget.dart';
import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/config/device_config.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //initialize width and height
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Consumer<AppState>(
      builder: (_, appState, __) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                appState.isModernBox ? ModernCalmBox() : TraditionalCalmBox(),
                HomeWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
