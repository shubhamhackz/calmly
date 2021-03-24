import 'dart:ui';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calmly/src/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/src/components/gradient_background.dart';
import 'package:calmly/src/bloc/breathe/breathe_event.dart';
import 'package:calmly/src/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/src/bloc/calm_box/calm_box_event.dart';
import 'package:calmly/src/bloc/bloc_provider.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_event.dart';

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
  // bool isExpanded = false;
  CalmBoxBloc _calmBoxBloc;
  BreatheBloc _breatheBloc;
  BreatheCounterBloc _breatheCounterBloc;
  int lastBreatheCount;
  CalmBox lastCalmBoxEvent;
  bool hasStarted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0.55,
      upperBound: 0.95,
    )..addStatusListener((AnimationStatus animationStatus) {
        print('Animation Status : $animationStatus');
        if (animationStatus == AnimationStatus.forward ||
            animationStatus == AnimationStatus.reverse) {
          _calmBoxBloc.calmBoxEventSink.add(BusyCalmBoxEvent());
          // _breatheBloc.inBreatheEvent.add(HoldBreatheEvent());
        } else if (animationStatus == AnimationStatus.completed) {
          _calmBoxBloc.calmBoxEventSink.add(CompletedExpandCalmBoxEvent());
          _breatheBloc.inBreatheEvent.add(IdleEvent());
        } else if (animationStatus == AnimationStatus.dismissed) {
          print('Last CalmBoxEvent : $lastCalmBoxEvent');
          if (lastCalmBoxEvent == CalmBox.completedExpand) {
            _breatheBloc.inBreatheEvent.add(IdleEvent());
          } else {
            _calmBoxBloc.calmBoxEventSink.add(CompletedShrinkCalmBoxEvent());
            _breatheBloc.inBreatheEvent.add(IdleEvent());
          }
        }
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
    _breatheBloc = BlocProvider.of(context).breatheBloc;
    _breatheCounterBloc = BlocProvider.of(context).breatheCounterBloc;
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
              if (calmBox == CalmBox.stop) {
                _animationController.duration =
                    const Duration(milliseconds: 250);
                _animationController.stop();
              }
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => handleTap(calmBox),
                child: Container(
                  alignment: Alignment.center,
                  width: width,
                  height: height * 0.5,
                  // child: Container(
                  //   width: width * _animationController.value,
                  //   height: width * _animationController.value,
                  //   child: GradientBackground(
                  //     isCircle: true,
                  //     colors: <Color>[
                  //       const Color(0xFFFCE800),
                  //       const Color(0xFFFFD100),
                  //       const Color(0xFFFFA800),
                  //       const Color(0xFFFF7B2A),
                  //       const Color(0xFFFD007A),
                  //       const Color(0xFFFB0086),
                  //       const Color(0xFFFB0085),
                  //     ],
                  //   ),
                  // ),
                  child: AnimatedBuilder(
                    builder: (_, __) {
                      return Container(
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
                      );
                    },
                    animation: _animationController,
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

  // void handleTap(CalmBox calmBox) {
  //   if (calmBox != CalmBox.busy) {
  //     HapticFeedback.vibrate();
  //     if (calmBox == CalmBox.expand || calmBox == CalmBox.completedExpand) {
  //       _calmBoxBloc.calmBoxEventSink.add(ShrinkCalmBoxEvent());
  //       _breatheBloc.inBreatheEvent.add(InhaleEvent());
  //       _animationController.reverse();
  //     } else if (calmBox == CalmBox.shrink ||
  //         calmBox == CalmBox.completedShrink) {
  //       _calmBoxBloc.calmBoxEventSink.add(ExpandCalmBoxEvent());
  //       _breatheBloc.inBreatheEvent.add(ExhaleEvent());
  //       _animationController.forward();
  //     }
  //   }
  // }

  void handleTap(CalmBox calmBox) {
    if (calmBox != CalmBox.busy) {
      HapticFeedback.vibrate();
      startCalmly();
      hasStarted = true;
    }
  }

  exhale() {
    developer.log('Exhale');
    _calmBoxBloc.calmBoxEventSink.add(ShrinkCalmBoxEvent());
    _breatheBloc.inBreatheEvent.add(ExhaleEvent());
    _animationController.duration = const Duration(milliseconds: 2000); //2000
    _animationController.reverse();
  }

  inhale() {
    developer.log('Inhale');
    _calmBoxBloc.calmBoxEventSink.add(ExpandCalmBoxEvent());
    _breatheBloc.inBreatheEvent.add(InhaleEvent());
    _animationController.duration = const Duration(milliseconds: 1000); //4000
    _animationController.forward();
  }

  startCalmly() {
    inhale();
    if (!hasStarted) {
      // don't listen if we are already listening

      _breatheCounterBloc.outBreatheCounter.listen(mapBreatheCount);
      _calmBoxBloc.outCalmBox.listen((calmBoxValue) {
        lastCalmBoxEvent = calmBoxValue;
        if (calmBoxValue == CalmBox.cancel) {
          // setState(() {
          //   _animationController.value = _animationController.lowerBound;
          // });

          // _animationController.stop(canceled: true);
          _animationController.duration = const Duration(milliseconds: 200);
          _animationController.animateTo(_animationController.lowerBound);
          print('Animation Controller value: ${_animationController.value}');
        } else if (calmBoxValue == CalmBox.completedExpand) {
          _breatheBloc.inBreatheEvent.add(HoldBreatheEvent());
          // Future.delayed(const Duration(milliseconds: 500), () {
          // 7000
          exhale();
          // });
        } else if (calmBoxValue == CalmBox.completedShrink) {
          _breatheCounterBloc.inBreatheCounterEvent
              .add(OneBreatheCounterEvent());
        }
      });
    }
  }

  mapBreatheCount(breatheCount) {
    lastBreatheCount = breatheCount;
    if (breatheCount == 0) {
      stopCalmly();
    } else if (breatheCount == -1) {
      cancelCalmly();
    } else {
      // Future.delayed(const Duration(milliseconds: 1000), () {
      inhale();
      // });
    }
  }

  stopCalmly() {
    _calmBoxBloc.calmBoxEventSink.add(StopCalmBoxEvent());
    _breatheCounterBloc.inBreatheCounterEvent
        .add(CompletedBreatheCounterEvent());

    _breatheBloc.inBreatheEvent.add(IdleEvent());
  }

  cancelCalmly() {
    _calmBoxBloc.calmBoxEventSink.add(CancelCalmBoxEvent());
    _breatheCounterBloc.inBreatheCounterEvent
        .add(CompletedBreatheCounterEvent());

    _breatheBloc.inBreatheEvent.add(IdleEvent());
  }

  @override
  void dispose() {
    _calmBoxBloc.dispose();
    _breatheBloc.dispose();
    _breatheCounterBloc.dispose();
    super.dispose();
  }
}
