import 'dart:async';
import 'package:calmly/src/bloc/calm_box/calm_box_event.dart';

class CalmBoxBloc {
  CalmBox _calmBox;

  StreamController<CalmBox> _expandStreamController =
      StreamController<CalmBox>.broadcast();
  StreamSink<CalmBox> get _inCalmBox => _expandStreamController.sink;
  Stream<CalmBox> get outCalmBox =>
      _expandStreamController.stream.asBroadcastStream();

  StreamController<CalmBoxEvent> _calmBoxEventController =
      StreamController<CalmBoxEvent>();
  StreamSink<CalmBoxEvent> get calmBoxEventSink => _calmBoxEventController.sink;

  CalmBoxBloc() {
    _calmBoxEventController.stream.listen(_mapEventToState);
  }

  _mapEventToState(CalmBoxEvent calmBoxEvent) {
    if (calmBoxEvent is ExpandCalmBoxEvent) {
      _calmBox = CalmBox.expand;
    } else if (calmBoxEvent is ShrinkCalmBoxEvent) {
      _calmBox = CalmBox.shrink;
    } else if (calmBoxEvent is BusyCalmBoxEvent) {
      _calmBox = CalmBox.busy;
    } else if (calmBoxEvent is CompletedExpandCalmBoxEvent) {
      _calmBox = CalmBox.completedExpand;
    } else if (calmBoxEvent is CompletedShrinkCalmBoxEvent) {
      _calmBox = CalmBox.completedShrink;
    } else if (calmBoxEvent is CancelCalmBoxEvent) {
      _calmBox = CalmBox.cancel;
    } else if (calmBoxEvent is StopCalmBoxEvent) {
      _calmBox = CalmBox.stop;
    }
    print('CalmBoxState = $_calmBox');
    _inCalmBox.add(_calmBox);
  }

  void dispose() {
    _expandStreamController.close();
    _calmBoxEventController.close();
  }
}

enum CalmBox {
  expand,
  shrink,
  busy,
  completedExpand,
  completedShrink,
  cancel,
  stop,
}
