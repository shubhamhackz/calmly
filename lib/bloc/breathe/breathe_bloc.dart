import 'dart:async';

import 'package:calmly/bloc/breathe/breathe_event.dart';

class BreatheBloc {
  Breathe _breathe;

  StreamController<Breathe> _breatheController = StreamController<Breathe>();
  StreamSink<Breathe> get _inBreathe => _breatheController.sink;
  Stream<Breathe> get outBreathe => _breatheController.stream;

  StreamController<BreatheEvent> _breatheEventController =
      StreamController<BreatheEvent>();
  StreamSink<BreatheEvent> get inBreatheEvent => _breatheEventController.sink;
  Stream<BreatheEvent> get _outBreatheEvent => _breatheEventController.stream;

  BreatheBloc() {
    _outBreatheEvent.listen(_mapEventToState);
  }

  void _mapEventToState(BreatheEvent breatheEvent) {
    if (breatheEvent is InhaleEvent) {
      _breathe = Breathe.inhale;
    } else if (breatheEvent is HoldBreatheEvent) {
      _breathe = Breathe.holdBreathe;
    } else if (breatheEvent is ExhaleEvent) {
      _breathe = Breathe.exhale;
    }

    _inBreathe.add(_breathe);
  }

  void dispose() {
    _breatheController.close();
    _breatheEventController.close();
  }
}

enum Breathe {
  inhale,
  holdBreathe,
  exhale,
}
