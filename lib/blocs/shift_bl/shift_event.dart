abstract class ShiftEvent {}

class LoadShifts extends ShiftEvent {}

class AddShift extends ShiftEvent {
  final String day;
  final String time;
  final String location;
  final String coordinatorId;
  final String groupId;

  AddShift({
    required this.day,
    required this.time,
    required this.location,
    required this.coordinatorId,
    required this.groupId,
  });
}

class UpdateShift extends ShiftEvent {
  final String shiftId;
  final String? day;
  final String? time;
  final String? location;
  final List<String>? coordinatorIds;
  final String? groupId;

  UpdateShift({
    required this.shiftId,
    this.day,
    this.time,
    this.location,
    this.coordinatorIds,
    this.groupId,
  });
}

class DeleteShift extends ShiftEvent {
  final String shiftId;

  DeleteShift(this.shiftId);
}

class AssignCoordinatorToShift extends ShiftEvent {
  final String shiftId;
  final String coordinatorId;

  AssignCoordinatorToShift({
    required this.shiftId,
    required this.coordinatorId,
  });
}

class RemoveCoordinatorFromShift extends ShiftEvent {
  final String shiftId;
  final String coordinatorId;

  RemoveCoordinatorFromShift({
    required this.shiftId,
    required this.coordinatorId,
  });
}

class AssignStewardToShift extends ShiftEvent {
  final String shiftId;
  final String stewardId;

  AssignStewardToShift({required this.shiftId, required this.stewardId});
}

class RemoveStewardFromShift extends ShiftEvent {
  final String shiftId;
  final String stewardId;

  RemoveStewardFromShift({required this.shiftId, required this.stewardId});
}
