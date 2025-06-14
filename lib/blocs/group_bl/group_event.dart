abstract class GroupEvent {}

class LoadGroups extends GroupEvent {}

class CreateGroup extends GroupEvent {
  final String name;
  final String description;
  final String coordinatorId;

  CreateGroup({
    required this.name,
    required this.description,
    required this.coordinatorId,
  });
}

class UpdateGroup extends GroupEvent {
  final String groupId;
  final String? name;
  final String? description;
  final String? coordinatorId;

  UpdateGroup({
    required this.groupId,
    this.name,
    this.description,
    this.coordinatorId,
  });
}

class DeleteGroup extends GroupEvent {
  final String groupId;

  DeleteGroup(this.groupId);
}

class AddMemberToGroup extends GroupEvent {
  final String groupId;
  final String memberId;

  AddMemberToGroup({required this.groupId, required this.memberId});
}

class RemoveMemberFromGroup extends GroupEvent {
  final String groupId;
  final String memberId;

  RemoveMemberFromGroup({required this.groupId, required this.memberId});
}
