abstract class CalmBoxEvent {}

class ExpandCalmBoxEvent extends CalmBoxEvent {}

class ShrinkCalmBoxEvent extends CalmBoxEvent {}

class BusyCalmBoxEvent extends CalmBoxEvent {}

class CompletedExpandCalmBoxEvent extends CalmBoxEvent {}

class CompletedShrinkCalmBoxEvent extends CalmBoxEvent {}

class CancelCalmBoxEvent extends CalmBoxEvent {}

class StopCalmBoxEvent extends CalmBoxEvent {}
