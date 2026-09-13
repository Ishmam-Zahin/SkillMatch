class MyAddJobEvents {}

class UploadJobEvent extends MyAddJobEvents {
  final String title;
  final String dsc;
  final String deadlineDate;
  final String userId;
  final int typeId;
  final List<String> requiredSkills;

  UploadJobEvent({
    required this.title,
    required this.dsc,
    required this.deadlineDate,
    required this.userId,
    required this.typeId,
    required this.requiredSkills,
  });
}
