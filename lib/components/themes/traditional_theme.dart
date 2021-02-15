import 'package:flutter/material.dart';
import 'package:calmly/components/gradient_background.dart';
import 'package:calmly/components/white_line.dart';
import 'package:flutter/services.dart';

class TraditionalTheme extends StatefulWidget {
  @override
  _TraditionalThemeState createState() => _TraditionalThemeState();
}

class _TraditionalThemeState extends State<TraditionalTheme> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: height * 0.265,
          child: Container(
            width: width,
            height: height * 0.5,
            child: Stack(
              children: [
                GradientBackground(),
                Positioned(
                  top: height * 0.24,
                  child: WhiteLine(height: height * 0.0039, width: width),
                ),
                Positioned(
                  top: height * 0.28,
                  child: WhiteLine(height: height * 0.01, width: width),
                ),
                Positioned(
                  top: height * 0.32,
                  child: WhiteLine(height: height * 0.017, width: width),
                ),
                Positioned(
                  top: height * 0.36,
                  child: WhiteLine(height: height * 0.028, width: width),
                ),
                Positioned(
                  top: height * 0.4,
                  child: WhiteLine(height: height * 0.035, width: width),
                ),
                Positioned(
                  top: height * 0.5,
                  child: WhiteLine(height: height * 0.034, width: width),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.vibrate();
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcOut,
            ), // This one will create the magic
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ), // This one will handle background + difference out
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 4000),
                    height: isExpanded ? width * 0.95 : width * 0.655,
                    width: isExpanded ? width * 0.95 : width * 0.655,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(width * 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
