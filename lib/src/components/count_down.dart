import 'dart:async';

import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  const CountDown({
    Key key,
    this.countDownTime,
  }) : super(key: key);
  final int countDownTime;
  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  Timer _timer;
  int _time;
  void startTimer() {
    _time = widget.countDownTime;
    var _interval = const Duration(seconds: 1);
    _timer = Timer.periodic(_interval, (_) {
      print('Time : $_time');
      if (_time <= 0) {
        _timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _time--;
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  cancelCount() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '0${_time ?? 0}',
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
