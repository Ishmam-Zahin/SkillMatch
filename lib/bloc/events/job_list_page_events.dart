class MyJobListPageEvents {}

class LoadJobListEvent extends MyJobListPageEvents {
  final int typeId;
  final String? userId;
  final List<String> userSkills;
  LoadJobListEvent({
    required this.typeId,
    this.userId,
    this.userSkills = const [],
  });
}
