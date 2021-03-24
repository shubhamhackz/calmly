import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:calmly/screens/home_screen.dart';
import 'package:calmly/bloc/bloc_provider.dart';
import 'package:calmly/bloc/breathe/breathe_bloc.dart';
import 'package:calmly/bloc/calm_box/calm_box_bloc.dart';
import 'package:calmly/bloc/breathe/breathe_counter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        child: HomeScreen(),
      ),
    );
  }
}
