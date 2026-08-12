class MyJobCommentsEvents {}

class LoadCommentsEvent extends MyJobCommentsEvents {
  final int jobId;

  LoadCommentsEvent({
    required this.jobId,
  });
}

class PostCommentEvent extends MyJobCommentsEvents {
  final String userId;
  final int jobId;
  final String comTxt;

  PostCommentEvent({
    required this.userId,
    required this.jobId,
    required this.comTxt,
  });
}
