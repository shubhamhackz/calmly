import 'dart:ui';

import 'package:calmly/components/calm_box/traditional_calm_box.dart';
import 'package:flutter/material.dart';
import 'package:calmly/components/gradient_background.dart';
import 'package:flutter/services.dart';

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
      body: Stack(
        children: [
          Positioned(
            top: height * 0.265,
            child: Container(
              alignment: Alignment.center,
              width: width,
              height: height * 0.5,
              child: Container(
                width: width * 0.655,
                height: width * 0.655,
                child: GradientBackground(
                  isCircle: true,
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.5,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 20, sigmaY: 100), //sigmaX = 0 (expanded)
                child: Container(
                  height: height * 0.5,
                  width: width,
                  color: const Color(0xFFF3F6F6).withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
      // body: TraditionalCalmBox(),
    );
  }
}
