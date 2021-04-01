import 'dart:async';
import 'dart:ui';
import 'dart:developer' as developer;

import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/utils/system_theme.dart';
import 'package:flutter/material.dart';

import 'package:calmly/src/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/src/components/gradient_background.dart';
import 'package:calmly/src/bloc/breathe/breathe_event.dart';
import 'package:calmly/src/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/src/bloc/calm_box/calm_box_event.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_event.dart';
import 'package:calmly/src/screens/congrats_screen.dart';
import 'package:calmly/src/utils/local_db.dart';
import 'package:calmly/src/config/device_config.dart';
import 'package:calmly/src/constants/constants.dart';

import 'package:vibration/vibration.dart';
import 'package:provider/provider.dart';

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
  StreamSubscription _breatheCounterSubscription;
  StreamSubscription _calmBoxSubscription;
  CalmBoxBloc _calmBoxBloc;
  BreatheBloc _breatheBloc;
  BreatheCounterBloc _breatheCounterBloc;
  int lastBreatheCount;
  CalmBox lastCalmBoxEvent;
  bool hasStarted = false;
  AppState _appState;
  bool isDark;

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
    _calmBoxBloc = Provider.of<CalmBoxBloc>(context);
    _breatheBloc = Provider.of<BreatheBloc>(context);
    _breatheCounterBloc = Provider.of<BreatheCounterBloc>(context);
    _appState = Provider.of<AppState>(context);
    isDark = SystemTheme.isDark(_appState);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      child: Stack(
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
                    color: (isDark
                            ? const Color(0xFF020202)
                            : const Color(0xFFF3F6F6))
                        .withOpacity(_opacityTween.value),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleTap(CalmBox calmBox) {
    if (calmBox != CalmBox.busy) {
      startCalmly();
      hasStarted = true;
    }
  }

  vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 70);
    }
  }

  exhale() {
    developer.log('Exhale');
    if (_appState.isVibrationOn) {
      vibrate();
    }
    _calmBoxBloc.calmBoxEventSink.add(ShrinkCalmBoxEvent());
    _breatheBloc.inBreatheEvent.add(ExhaleEvent());
    _animationController.duration = const Duration(milliseconds: 8000); //8000
    _animationController.reverse();
  }

  inhale() async {
    developer.log('Inhale');
    if (_appState.isVibrationOn) {
      vibrate();
    }
    _calmBoxBloc.calmBoxEventSink.add(ExpandCalmBoxEvent());
    _breatheBloc.inBreatheEvent.add(InhaleEvent());
    _animationController.duration = const Duration(milliseconds: 4000); //4000
    _animationController.forward();
  }

  startCalmly() {
    inhale();
    if (!hasStarted) {
      // don't listen if we are already listening

      _breatheCounterSubscription =
          _breatheCounterBloc.outBreatheCounter.listen(mapBreatheCount);
      _calmBoxSubscription = _calmBoxBloc.outCalmBox.listen(mapCalmBoxEvent);
    }
  }

  mapCalmBoxEvent(calmBoxValue) {
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
      Future.delayed(const Duration(milliseconds: 7000), () {
        // 7000
        exhale();
      });
    } else if (calmBoxValue == CalmBox.completedShrink) {
      _breatheCounterBloc.inBreatheCounterEvent.add(OneBreatheCounterEvent());
    }
  }

  mapBreatheCount(breatheCount) {
    lastBreatheCount = breatheCount;
    if (breatheCount == 0) {
      stopCalmly();
    } else if (breatheCount == -1) {
      cancelCalmly();
    } else {
      Future.delayed(const Duration(milliseconds: 700), () {
        inhale();
      });
    }
  }

  stopCalmly() {
    _calmBoxBloc.calmBoxEventSink.add(StopCalmBoxEvent());
    _breatheCounterBloc.inBreatheCounterEvent
        .add(CompletedBreatheCounterEvent());

    _breatheBloc.inBreatheEvent.add(IdleEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCongratsScreen();
    });
  }

  cancelCalmly() {
    _calmBoxBloc.calmBoxEventSink.add(CancelCalmBoxEvent());
    _breatheCounterBloc.inBreatheCounterEvent
        .add(CompletedBreatheCounterEvent());

    _breatheBloc.inBreatheEvent.add(IdleEvent());
  }

  @override
  void dispose() {
    // _calmBoxBloc.dispose();
    // _breatheBloc.dispose();
    // _breatheCounterBloc.dispose();
    _breatheCounterSubscription.cancel();
    _calmBoxSubscription.cancel();
    super.dispose();
  }

  showCongratsScreen() {
    LocalDB localDB = LocalDB();
    int count = localDB.getTotalCalmly ?? 0;
    localDB.saveTotalCalmly(++count);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CongratsScreen(),
      ),
    );
  }
}
