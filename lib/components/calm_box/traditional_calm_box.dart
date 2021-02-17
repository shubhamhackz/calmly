import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calmly/components/gradient_background.dart';
import 'package:calmly/components/white_line.dart';
import 'package:calmly/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/bloc/calm_box/calm_box_event.dart';
import 'package:calmly/bloc/bloc_provider.dart';

class TraditionalCalmBox extends StatefulWidget {
  @override
  _TraditionalCalmBoxState createState() => _TraditionalCalmBoxState();
}

class _TraditionalCalmBoxState extends State<TraditionalCalmBox>
    with SingleTickerProviderStateMixin {
  CalmBoxBloc _calmBoxBloc;
  AnimationController _animationController;
  double radius = 0.55;

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calmBoxBloc = BlocProvider.of(context).calmBoxBloc;
  }

  void initController() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 4000),
        vsync: this,
        lowerBound: 0.55,
        upperBound: 0.95)
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
                      child: Container(
                        height: width * _animationController.value,
                        width: width * _animationController.value,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(width * 0.5),
                        ),
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
