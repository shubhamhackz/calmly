import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';

import 'package:calmly/src/config/app_state.dart';
import 'package:calmly/src/utils/system_theme.dart';
import 'package:calmly/src/utils/local_db.dart';
import 'package:calmly/src/config/device_config.dart';

class CongratsScreen extends StatefulWidget {
  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  ConfettiController _controller;
  AppState _appState;
  bool isDark;
  int totalCalmlyCount;
  @override
  void initState() {
    super.initState();
    _controller = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
    totalCalmlyCount = LocalDB().getTotalCalmly ?? 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = Provider.of<AppState>(context);
    isDark = SystemTheme.isDark(_appState);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play();
    });
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          ConfettiWidget(
            blastDirectionality: BlastDirectionality.explosive,
            confettiController: _controller,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 25,
            gravity: 0.05,
            shouldLoop: false,
            colors: [
              Colors.green,
              Colors.red,
              Colors.yellow,
              Colors.blue,
              Colors.lime
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.075, horizontal: width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$totalCalmlyCount',
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Congratulations',
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: width * 0.35,
                        padding:
                            EdgeInsets.symmetric(horizontal: width * 0.025),
                        child: Text(
                          'Breathing Session Completed',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.025),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Close',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
