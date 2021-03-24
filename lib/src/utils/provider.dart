import 'package:flutter/material.dart';

import 'package:calmly/src/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/src/bloc/breathe/breathe_counter_bloc.dart';
import 'package:calmly/src/config/app_state.dart';

class Provider extends InheritedWidget {
  Provider(
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
  final AppState appState;

  static Provider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>();
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return true;
  }
}
