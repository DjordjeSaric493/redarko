import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redarko/services/supabase_serv.dart';
import 'package:redarko/models/group_m.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final SupabaseService supabaseService;

  GroupBloc(this.supabaseService) : super(GroupInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<CreateGroup>(_onCreateGroup);
    on<UpdateGroup>(_onUpdateGroup);
    on<DeleteGroup>(_onDeleteGroup);
    on<AddMemberToGroup>(_onAddMemberToGroup);
    on<RemoveMemberFromGroup>(_onRemoveMemberFromGroup);
  }

  Future<void> _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      final groups = await supabaseService.getGroups();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onCreateGroup(
    CreateGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      final group = GroupModel(
        id: '', // Will be set by Supabase
        name: event.name,
        description: event.description,
        coordinatorId: event.coordinatorId,
        memberIds: [event.coordinatorId], // Coordinator is first member
        createdAt: DateTime.now(),
      );

      await supabaseService.createGroup(group);
      emit(GroupOperationSuccess('Grupa uspešno kreirana'));

      // Reload groups after creating
      final groups = await supabaseService.getGroups();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onUpdateGroup(
    UpdateGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      await supabaseService.updateGroup(
        event.groupId,
        name: event.name,
        description: event.description,
        coordinatorId: event.coordinatorId,
      );
      emit(GroupOperationSuccess('Grupa uspešno ažurirana'));

      // Reload groups after updating
      final groups = await supabaseService.getGroups();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onDeleteGroup(
    DeleteGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      await supabaseService.deleteGroup(event.groupId);
      emit(GroupOperationSuccess('Grupa uspešno obrisana'));

      // Reload groups after deleting
      final groups = await supabaseService.getGroups();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onAddMemberToGroup(
    AddMemberToGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      await supabaseService.addMemberToGroup(event.groupId, event.memberId);
      emit(GroupOperationSuccess('Član uspešno dodat u grupu'));

      // Reload groups after adding member
      final groups = await supabaseService.getGroups();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }

  Future<void> _onRemoveMemberFromGroup(
    RemoveMemberFromGroup event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoading());
    try {
      await supabaseService.removeMemberFromGroup(
        event.groupId,
        event.memberId,
      );
      emit(GroupOperationSuccess('Član uspešno uklonjen iz grupe'));

      // Reload groups after removing member
      final groups = await supabaseService.getGroups();
      emit(GroupLoaded(groups));
    } catch (e) {
      emit(GroupError(e.toString()));
    }
  }
}
