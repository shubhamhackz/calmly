import 'package:flutter/material.dart';

import 'package:calmly/src/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_bloc.dart';
import 'package:calmly/src/config/app_state_notifier.dart';

class BlocProvider extends InheritedWidget {
  BlocProvider(
      {Key key,
      this.child,
      this.calmBoxBloc,
      this.breatheBloc,
      this.appState,
      this.breatheCounterBloc})
      : super(key: key, child: child);

  final Widget child;
  final CalmBoxBloc calmBoxBloc;
  final BreatheBloc breatheBloc;
  final BreatheCounterBloc breatheCounterBloc;
  final AppStateNotifier appState;

  static BlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>();
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return true;
  }
}
