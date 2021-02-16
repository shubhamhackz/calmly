import 'dart:ui';

import 'package:calmly/components/gradient_background.dart';
import 'package:flutter/material.dart';

class ModernCalmBox extends StatefulWidget {
  @override
  _ModernCalmBoxState createState() => _ModernCalmBoxState();
}

class _ModernCalmBoxState extends State<ModernCalmBox>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacityTween;
  Animation<double> _sigmaXTween;
  Animation<double> _sigmaYTween;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0.55,
      upperBound: 1.0,
    )..addListener(() {
        setState(() {});
      });
    _opacityTween =
        Tween<double>(begin: 0.0, end: 0.35).animate(_animationController);
    _sigmaXTween =
        Tween<double>(begin: 0.03, end: 0.04).animate(_animationController);
    _sigmaYTween =
        Tween<double>(begin: 0.225, end: 0.25).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: height * 0.265,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              print('Tapped!');
              isExpanded
                  ? _animationController.forward()
                  : _animationController.reverse();
              isExpanded = !isExpanded;
            },
            child: Container(
              alignment: Alignment.center,
              width: width,
              height: height * 0.5,
              child: Container(
                width: width * _animationController.value,
                height: width * _animationController.value,
                child: GradientBackground(
                  isCircle: true,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height * 0.51,
          child: IgnorePointer(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: height * _sigmaXTween.value,
                  sigmaY: width * _sigmaYTween.value,
                ), //sigmaX = 0 (expanded)
                child: Container(
                  height: height * 0.5,
                  width: width,
                  color:
                      const Color(0xFFF3F6F6).withOpacity(_opacityTween.value),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
