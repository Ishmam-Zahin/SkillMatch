class MyAddJobEvents {}

class UploadJobEvent extends MyAddJobEvents {
  final String title;
  final String dsc;
  final String deadlineDate;
  final String userId;
  final int typeId;

  UploadJobEvent({
    required this.title,
    required this.dsc,
    required this.deadlineDate,
    required this.userId,
    required this.typeId,
  });
}
