import 'package:skillmatch/data/model/job_detail_model.dart';

class MyJobDetailStates {}

class JobDetailInitialState extends MyJobDetailStates {}

class JobDetailLoadingState extends MyJobDetailStates {}

class JobDetailLoadedState extends MyJobDetailStates {
  final MyJobDetailModel job;
  JobDetailLoadedState({
    required this.job,
  });
}

class JobDetailErrorState extends MyJobDetailStates {
  final String error;
  JobDetailErrorState({required this.error});
}
