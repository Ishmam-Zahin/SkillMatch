import 'package:skillmatch/data/model/job_comments_model.dart';

class MyJobCommentsStates {}

class JobCommentsInitialState extends MyJobCommentsStates {}

class JobCommentsLoadingState extends MyJobCommentsStates {}

class JobCommentsLoadedState extends MyJobCommentsStates {
  final MyJobCommentsModel comments;

  JobCommentsLoadedState({
    required this.comments,
  });
}

class JobCommentsErrorState extends MyJobCommentsStates {
  final String error;

  JobCommentsErrorState({
    required this.error,
  });
}

class PostJobCommentInitialState extends MyJobCommentsStates {}

class PostJobCommentLoadingState extends MyJobCommentsStates {}

class PostJobCommentLoadedState extends MyJobCommentsStates {}

class PostJobCommentErrorState extends MyJobCommentsStates {
  final String error;

  PostJobCommentErrorState({
    required this.error,
  });
}
