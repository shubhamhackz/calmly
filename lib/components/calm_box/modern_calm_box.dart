import 'dart:ui';
import 'package:calmly/bloc/calm_box/calm_box_event.dart';
import 'package:flutter/material.dart';

import 'package:calmly/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/components/gradient_background.dart';
import 'package:calmly/bloc/bloc_provider.dart';
import 'package:flutter/services.dart';

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
  CalmBoxBloc _calmBoxBloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0.55,
      upperBound: 0.95,
    )
      ..addStatusListener((AnimationStatus animationStatus) {
        print('Animation Status $animationStatus');
        if (animationStatus == AnimationStatus.forward ||
            animationStatus == AnimationStatus.reverse) {
          _calmBoxBloc.calmBoxEventSink.add(BusyCalmBoxEvent());
        } else if (animationStatus == AnimationStatus.completed) {
          _calmBoxBloc.calmBoxEventSink.add(CompletedExpandCalmBoxEvent());
        } else if (animationStatus == AnimationStatus.dismissed) {
          _calmBoxBloc.calmBoxEventSink.add(CompletedShrinkCalmBoxEvent());
        }
      })
      ..addListener(() {
        setState(() {});
      });
    _opacityTween =
        Tween<double>(begin: 0.0, end: 0.35).animate(_animationController);
    _sigmaXTween =
        Tween<double>(begin: 0.03, end: 0.1).animate(_animationController);
    _sigmaYTween =
        Tween<double>(begin: 0.13, end: 0.18).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calmBoxBloc = BlocProvider.of(context).calmBoxBloc;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          top: height * 0.265,
          child: StreamBuilder(
            initialData: CalmBox.shrink,
            stream: _calmBoxBloc.outCalmBox,
            builder: (BuildContext context, AsyncSnapshot<CalmBox> snapshot) {
              CalmBox calmBox = snapshot.data;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => handleTap(calmBox),
                child: Container(
                  alignment: Alignment.center,
                  width: width,
                  height: height * 0.5,
                  child: Container(
                    width: width * _animationController.value,
                    height: width * _animationController.value,
                    child: GradientBackground(
                      isCircle: true,
                      colors: <Color>[
                        const Color(0xFFFCE800),
                        const Color(0xFFFFD100),
                        const Color(0xFFFFA800),
                        const Color(0xFFFF7B2A),
                        const Color(0xFFFD007A),
                        const Color(0xFFFB0086),
                        const Color(0xFFFB0085),
                      ],
                    ),
                  ),
                ),
              );
            },
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

  void handleTap(CalmBox calmBox) {
    if (calmBox != CalmBox.busy) {
      HapticFeedback.vibrate();
      if (calmBox == CalmBox.expand || calmBox == CalmBox.completedExpand) {
        _calmBoxBloc.calmBoxEventSink.add(ShrinkCalmBoxEvent());
        _animationController.reverse();
      } else if (calmBox == CalmBox.shrink ||
          calmBox == CalmBox.completedShrink) {
        _calmBoxBloc.calmBoxEventSink.add(ExpandCalmBoxEvent());
        _animationController.forward();
      }
    }
  }
}
