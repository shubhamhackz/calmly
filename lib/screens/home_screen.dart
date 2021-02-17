import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:calmly/constants/custom_icons_icons.dart';
import 'package:calmly/components/calm_box/traditional_calm_box.dart';
import 'package:calmly/components/calm_box/modern_calm_box.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            ModernCalmBox(),
            Container(
              margin: EdgeInsets.only(
                left: width * 0.05,
                right: width * 0.05,
                // top: height * 0.1,
                // bottom: height * 0.05,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.baseline,
                    // textBaseline: TextBaseline.alphabetic,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Focus /\nBreathe /\nRelax /\n",
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            CustomIcons.dot_3,
                            size: width * 0.1,
                          ),
                        ],
                      ),
                      Text(
                        '04',
                        style: const TextStyle(
                            fontSize: 100, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ), //upper widgets
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.baseline,
                    // textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "Tap\nCircle to\nstart",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '00',
                        style: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ), //borrom widgets
                ],
              ),
            ),
          ],
        ),
      ),
      // body: TraditionalCalmBox(),
    );
  }
}
