import 'package:calmly/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/bloc_provider.dart';
import 'bloc/breathe/breathe_bloc.dart';
import 'bloc/breathe/breathe_counter_bloc.dart';
import 'bloc/calm_box/calm_box_bloc.dart';
import 'config/app_state_notifier.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ); //change statusbar cxolor
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        calmBoxBloc: CalmBoxBloc(),
        breatheBloc: BreatheBloc(),
        breatheCounterBloc: BreatheCounterBloc(),
        appState: AppStateNotifier(),
        child: HomeScreen(),
      ),
    );
  }
}
