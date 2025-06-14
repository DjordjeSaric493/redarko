import 'package:redarko/models/group_m.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<GroupModel> groups;

  GroupLoaded(this.groups);
}

class GroupError extends GroupState {
  final String message;

  GroupError(this.message);
}

class GroupOperationSuccess extends GroupState {
  final String message;

  GroupOperationSuccess(this.message);
}
