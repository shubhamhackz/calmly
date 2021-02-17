import 'package:flutter/material.dart';

import 'package:calmly/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/bloc/breathe/breathe_bloc.dart';

class BlocProvider extends InheritedWidget {
  BlocProvider({Key key, this.child, this.calmBoxBloc, this.breatheBloc})
      : super(key: key, child: child);

  final Widget child;
  final CalmBoxBloc calmBoxBloc;
  final BreatheBloc breatheBloc;

  static BlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>();
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return true;
  }
}
