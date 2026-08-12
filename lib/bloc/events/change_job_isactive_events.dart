class MyChangeJobIsActiveEvent {}

class ChangeMyJobIsActiveEvent extends MyChangeJobIsActiveEvent {
  int jobId;
  bool status;
  ChangeMyJobIsActiveEvent({required this.jobId, required this.status});
}
