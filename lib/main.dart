import 'dart:io';

import 'package:flutter/material.dart';

import 'package:calmly/src/app.dart';
import 'src/bloc/breathe/breathe_bloc.dart';
import 'src/bloc/breathe/breathe_counter_bloc.dart';
import 'src/bloc/calm_box/calm_box_bloc.dart';
import 'src/config/app_state.dart';
import 'src/utils/local_db.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  var path = directory.path;
  Hive.init(path);
  await LocalDB().init();
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
