import 'dart:async';
import 'dart:developer' as developer;
import 'package:calmly/src/config/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vibration/vibration.dart';

import 'package:calmly/src/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_event.dart';
import 'package:calmly/src/bloc/breathe/breathe_event.dart';
import 'package:calmly/src/components/gradient_background.dart';
import 'package:calmly/src/components/white_line.dart';
import 'package:calmly/src/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/src/bloc/calm_box/calm_box_event.dart';
import 'package:calmly/src/utils/provider.dart';

class TraditionalCalmBox extends StatefulWidget {
  @override
  _TraditionalCalmBoxState createState() => _TraditionalCalmBoxState();
}

class _TraditionalCalmBoxState extends State<TraditionalCalmBox>
    with SingleTickerProviderStateMixin {
  StreamSubscription _breatheCounterSubscription;
  StreamSubscription _calmBoxSubscription;
  CalmBoxBloc _calmBoxBloc;
  AnimationController _animationController;
  double radius = 0.55;
  BreatheBloc _breatheBloc;
  BreatheCounterBloc _breatheCounterBloc;
  int lastBreatheCount;
  CalmBox lastCalmBoxEvent;
  bool hasStarted = false;
  AppState _appState;

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calmBoxBloc = Provider.of(context).calmBoxBloc;
    _breatheBloc = Provider.of(context).breatheBloc;
    _breatheCounterBloc = Provider.of(context).breatheCounterBloc;
    _appState = Provider.of(context).appState;
    _appState.addListener(() {
      setState(() {});
    });
  }

  void initController() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 4000),
        vsync: this,
        lowerBound: 0.55,
        upperBound: 0.95)
      ..addStatusListener((AnimationStatus animationStatus) {
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
  }

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
            height: height * 0.47,
            child: Stack(
              children: [
                GradientBackground(),
                Positioned(
                  top: height * 0.24,
                  child: WhiteLine(height: height * 0.0039, width: width),
                ),
                Positioned(
                  top: height * 0.2755, //28
                  child: WhiteLine(height: height * 0.01, width: width),
                ),
                Positioned(
                  top: height * 0.31, //32
                  child: WhiteLine(height: height * 0.017, width: width),
                ),
                Positioned(
                  top: height * 0.345,
                  child: WhiteLine(height: height * 0.018, width: width),
                ),
                Positioned(
                  top: height * 0.38,
                  child: WhiteLine(height: height * 0.028, width: width),
                ),
                Positioned(
                  top: height * 0.42,
                  child: WhiteLine(height: height * 0.03, width: width),
                ),
              ],
            ),
          ),
        ),
        StreamBuilder(
          initialData: CalmBox.shrink,
          stream: _calmBoxBloc.outCalmBox,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            CalmBox calmBox = snapshot.data;
            if (calmBox == CalmBox.stop) {
              _animationController.duration = const Duration(milliseconds: 250);
              _animationController.stop();
            }
            return GestureDetector(
              onTap: () => handleTap(calmBox),
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
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, __) {
                          return Container(
                            height: width * _animationController.value,
                            width: width * _animationController.value,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(width * 0.5),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void handleTap(CalmBox calmBox) {
    if (calmBox != CalmBox.busy) {
      HapticFeedback.heavyImpact();
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
    _animationController.duration = const Duration(milliseconds: 2000); //2000
    _animationController.reverse();
  }

  inhale() {
    developer.log('Inhale');
    if (_appState.isVibrationOn) {
      vibrate();
    }
    _calmBoxBloc.calmBoxEventSink.add(ExpandCalmBoxEvent());
    _breatheBloc.inBreatheEvent.add(InhaleEvent());
    _animationController.duration = const Duration(milliseconds: 1000); //4000
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
      // Future.delayed(const Duration(milliseconds: 500), () {
      // 7000
      exhale();
      // });
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
    // _calmBoxBloc.dispose();
    // _breatheBloc.dispose();
    // _breatheCounterBloc.dispose();
    _breatheCounterSubscription.cancel();
    _calmBoxSubscription.cancel();
    super.dispose();
  }
}
