import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/shift_m.dart';
import '../services/supabase_serv.dart';

// Events
abstract class ShiftEvent {}

class LoadShifts extends ShiftEvent {}

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

// States
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

// BLoC
class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final SupabaseService _supabaseService;

  ShiftBloc(this._supabaseService) : super(ShiftInitial()) {
    on<LoadShifts>(_onLoadShifts);
    on<AssignCoordinatorToShift>(_onAssignCoordinatorToShift);
    on<RemoveCoordinatorFromShift>(_onRemoveCoordinatorFromShift);
    on<AssignStewardToShift>(_onAssignStewardToShift);
    on<RemoveStewardFromShift>(_onRemoveStewardFromShift);
  }

  Future<void> _onLoadShifts(LoadShifts event, Emitter<ShiftState> emit) async {
    try {
      emit(ShiftLoading());
      final shifts = await _supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onAssignCoordinatorToShift(
    AssignCoordinatorToShift event,
    Emitter<ShiftState> emit,
  ) async {
    try {
      emit(ShiftLoading());
      await _supabaseService.assignCoordinatorToShift(
        event.shiftId,
        event.coordinatorId,
      );
      final shifts = await _supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onRemoveCoordinatorFromShift(
    RemoveCoordinatorFromShift event,
    Emitter<ShiftState> emit,
  ) async {
    try {
      emit(ShiftLoading());
      await _supabaseService.removeCoordinatorFromShift(
        event.shiftId,
        event.coordinatorId,
      );
      final shifts = await _supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onAssignStewardToShift(
    AssignStewardToShift event,
    Emitter<ShiftState> emit,
  ) async {
    try {
      emit(ShiftLoading());
      await _supabaseService.assignStewardToShift(
        event.shiftId,
        event.stewardId,
      );
      final shifts = await _supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onRemoveStewardFromShift(
    RemoveStewardFromShift event,
    Emitter<ShiftState> emit,
  ) async {
    try {
      emit(ShiftLoading());
      await _supabaseService.removeStewardFromShift(
        event.shiftId,
        event.stewardId,
      );
      final shifts = await _supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }
}
