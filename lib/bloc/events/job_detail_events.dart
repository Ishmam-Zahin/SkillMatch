class MyJobDetailEvents {}

class LoadJobDetailEvent extends MyJobDetailEvents {
  final int jobId;
  LoadJobDetailEvent({required this.jobId});
}
