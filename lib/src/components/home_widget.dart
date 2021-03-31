import 'package:flutter/material.dart';

import 'package:calmly/src/constants/custom_icons_icons.dart';
import 'package:calmly/src/components/settings_bottom_sheet.dart';
import 'package:calmly/src/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_event.dart';
import 'package:calmly/src/components/count_down.dart';
import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/utils/system_theme.dart';

import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  BreatheBloc _breatheBloc;
  BreatheCounterBloc _breatheCounterBloc;
  bool isDark;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _breatheBloc = Provider.of<BreatheBloc>(context);
    _breatheCounterBloc = Provider.of<BreatheCounterBloc>(context);
    AppState _appState = Provider.of<AppState>(context);
    isDark = SystemTheme.isDark(_appState);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<AppState>(builder: (_, appState, __) {
      isDark = SystemTheme.isDark(appState);
      return Container(
        margin: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.05,
          // top: height * 0.1,
          bottom: height * 0.05,
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
                    IconButton(
                      icon: Icon(
                        CustomIcons.dot_3,
                        size: width * 0.1,
                        color: isDark
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF000000),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            builder: (context) {
                              return SettingsBottomSheet();
                            },
                            context: context);
                      },
                    ),
                  ],
                ),
                StreamBuilder(
                  initialData: 04,
                  stream: _breatheCounterBloc.outBreatheCounter,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    int breatheCount = snapshot.data;
                    if (breatheCount == 0 || breatheCount == -1) {
                      breatheCount = 4;
                    }
                    return Text(
                      '$breatheCount',
                      style: const TextStyle(
                          fontSize: 100, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ), //upper widgets
            StreamBuilder(
              stream: _breatheBloc.outBreathe,
              initialData: Breathe.idle,
              builder: (BuildContext context, AsyncSnapshot<Breathe> snapshot) {
                Breathe breathe = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      mapBreathingInfo(breathe),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                      visible: breathe != Breathe.idle,
                      child: GestureDetector(
                        onTap: () {
                          _breatheCounterBloc.inBreatheCounterEvent
                              .add(EndBreatheCounterEvent());
                        },
                        child: Text(
                          'End now',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    mapCountDown(breathe),
                  ],
                );
              },
            ), //borrom widgets
          ],
        ),
      );
    });
  }

  CountDown mapCountDown(Breathe breathe) {
    CountDown countDown;
    if (breathe == Breathe.inhale) {
      countDown = CountDown(countDownTime: 4, key: UniqueKey());
    } else if (breathe == Breathe.holdBreathe) {
      countDown = CountDown(countDownTime: 7, key: UniqueKey());
    } else if (breathe == Breathe.exhale) {
      countDown = CountDown(countDownTime: 8);
    } else if (breathe == Breathe.idle) {
      countDown = CountDown(countDownTime: 0, key: UniqueKey());
    }
    return countDown;
  }
}

String mapBreathingInfo(Breathe breathe) {
  String breatheInfo;
  if (breathe == Breathe.inhale) {
    breatheInfo = 'Inhale\nfrom your\nnose';
  } else if (breathe == Breathe.holdBreathe) {
    breatheInfo = 'Hold\nyour\nbreathe';
  } else if (breathe == Breathe.exhale) {
    breatheInfo = 'Exhale\nfrom your\nmouth';
  }
  if (breathe == Breathe.idle) {
    breatheInfo = 'Tap\nCircle to\nstart';
  }
  return breatheInfo;
}
