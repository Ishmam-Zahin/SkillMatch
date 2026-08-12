class MyDeleteJobEvents {}

class DeleteJobEvent extends MyDeleteJobEvents {
  final int jobId;
  DeleteJobEvent({required this.jobId});
}
