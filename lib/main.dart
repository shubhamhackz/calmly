import 'package:flutter/material.dart';

import 'package:calmly/src/app.dart';
import 'src/bloc/breathe/breathe_bloc.dart';
import 'src/bloc/breathe/breathe_counter_bloc.dart';
import 'src/bloc/calm_box/calm_box_bloc.dart';
import 'src/config/app_state.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CalmBoxBloc>(create: (_) => CalmBoxBloc()),
        Provider<BreatheBloc>(create: (_) => BreatheBloc()),
        Provider<BreatheCounterBloc>(create: (_) => BreatheCounterBloc()),
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
      ],
      child: App(),
    ),
  );
}
