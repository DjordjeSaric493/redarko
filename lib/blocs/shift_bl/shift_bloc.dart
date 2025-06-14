import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redarko/services/supabase_serv.dart';
import 'package:redarko/models/shift_m.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final SupabaseService supabaseService;

  ShiftBloc(this.supabaseService) : super(ShiftInitial()) {
    on<LoadShifts>(_onLoadShifts);
    on<AddShift>(_onAddShift);
    on<UpdateShift>(_onUpdateShift);
    on<DeleteShift>(_onDeleteShift);
    on<AssignCoordinatorToShift>(_onAssignCoordinatorToShift);
    on<RemoveCoordinatorFromShift>(_onRemoveCoordinatorFromShift);
    on<AssignStewardToShift>(_onAssignStewardToShift);
    on<RemoveStewardFromShift>(_onRemoveStewardFromShift);
  }

  Future<void> _onLoadShifts(LoadShifts event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onAddShift(AddShift event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      final shift = ShiftModel(
        id: '', // Will be set by Supabase
        day: event.day,
        time: event.time,
        location: event.location,
        coordinatorIds: [event.coordinatorId], // Initial coordinator
        stewardIds: [],
        groupId: event.groupId,
        createdAt: DateTime.now(),
      );

      await supabaseService.createShift(shift);
      emit(ShiftOperationSuccess('Smena uspešno dodata'));

      // Reload shifts after adding
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onUpdateShift(
    UpdateShift event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());
    try {
      await supabaseService.updateShift(
        event.shiftId,
        day: event.day,
        time: event.time,
        location: event.location,
        coordinatorIds: event.coordinatorIds,
        groupId: event.groupId,
      );
      emit(ShiftOperationSuccess('Smena uspešno ažurirana'));

      // Reload shifts after updating
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onDeleteShift(
    DeleteShift event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());
    try {
      await supabaseService.deleteShift(event.shiftId);
      emit(ShiftOperationSuccess('Smena uspešno obrisana'));

      // Reload shifts after deleting
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onAssignCoordinatorToShift(
    AssignCoordinatorToShift event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());
    try {
      await supabaseService.assignCoordinatorToShift(
        event.shiftId,
        event.coordinatorId,
      );
      emit(ShiftOperationSuccess('Koordinator uspešno dodeljen smeni'));

      // Reload shifts after assigning
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onRemoveCoordinatorFromShift(
    RemoveCoordinatorFromShift event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());
    try {
      await supabaseService.removeCoordinatorFromShift(
        event.shiftId,
        event.coordinatorId,
      );
      emit(ShiftOperationSuccess('Koordinator uspešno uklonjen sa smene'));

      // Reload shifts after removing
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onAssignStewardToShift(
    AssignStewardToShift event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());
    try {
      await supabaseService.assignStewardToShift(
        event.shiftId,
        event.stewardId,
      );
      emit(ShiftOperationSuccess('Redar uspešno dodeljen smeni'));

      // Reload shifts after assigning
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onRemoveStewardFromShift(
    RemoveStewardFromShift event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());
    try {
      await supabaseService.removeStewardFromShift(
        event.shiftId,
        event.stewardId,
      );
      emit(ShiftOperationSuccess('Redar uspešno uklonjen sa smene'));

      // Reload shifts after removing
      final shifts = await supabaseService.getShifts();
      emit(ShiftLoaded(shifts));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }
}
