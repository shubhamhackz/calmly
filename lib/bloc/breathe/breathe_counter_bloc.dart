import 'dart:async';

import 'package:calmly/bloc/breathe/breathe_counter_event.dart';

class BreatheCounterBloc {
  int _breatheCounter = 4;

  StreamController<int> _breatheCounterStreamController =
      StreamController.broadcast();
  StreamSink<int> get _inBreatheCounter => _breatheCounterStreamController.sink;
  Stream<int> get outBreatheCounter =>
      _breatheCounterStreamController.stream.asBroadcastStream();

  StreamController<BreatheCounterEvent> _breatheCounterEventController =
      StreamController();
  StreamSink<BreatheCounterEvent> get inBreatheCounterEvent =>
      _breatheCounterEventController.sink;

  BreatheCounterBloc() {
    _breatheCounterEventController.stream.listen(_mapEventToState);
  }

  _mapEventToState(breatheCounterEvent) {
    if (breatheCounterEvent is OneBreatheCounterEvent) {
      _breatheCounter -= 1;
      _inBreatheCounter.add(_breatheCounter);
    } else if (breatheCounterEvent is CompletedBreatheCounterEvent) {
      _breatheCounter = 4;
      // _inBreatheCounter.add(_breatheCounter);
    } else if (breatheCounterEvent is EndBreatheCounterEvent) {
      _breatheCounter = -1;
      _inBreatheCounter.add(_breatheCounter);
      _breatheCounter = 4;
    }
    print('Breathe Count : $_breatheCounter');
  }

  void dispose() {
    _breatheCounterStreamController.close();
    _breatheCounterEventController.close();
  }
}
