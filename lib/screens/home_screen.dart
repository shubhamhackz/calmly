import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:calmly/components/calm_box/traditional_calm_box.dart';
import 'package:calmly/components/calm_box/modern_calm_box.dart';
import 'package:calmly/components/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: TraditionalCalmBox(),
      ),
      // body: TraditionalCalmBox(),
    );
  }
}
