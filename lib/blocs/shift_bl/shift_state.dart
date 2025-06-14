import 'package:redarko/models/shift_m.dart';

abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftLoaded extends ShiftState {
  final List<ShiftModel> shifts;

  ShiftLoaded(this.shifts);
}

class ShiftError extends ShiftState {
  final String message;

  ShiftError(this.message);
}

class ShiftOperationSuccess extends ShiftState {
  final String message;

  ShiftOperationSuccess(this.message);
}
