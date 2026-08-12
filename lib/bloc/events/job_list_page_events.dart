class MyJobListPageEvents {}

class LoadJobListEvent extends MyJobListPageEvents {
  final int typeId;
  final String? userId;
  LoadJobListEvent({required this.typeId, this.userId});
}
