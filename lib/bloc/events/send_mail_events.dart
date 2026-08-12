class MySendMailEvents {}

class SendMailEvent extends MySendMailEvents {
  final String userEmail;
  final String userId;
  final int jobId;

  SendMailEvent({
    required this.userEmail,
    required this.userId,
    required this.jobId,
  });
}

class SendMailValidityCheckEvent extends MySendMailEvents {
  final String userId;
  final int jobId;

  SendMailValidityCheckEvent({
    required this.userId,
    required this.jobId,
  });
}
