import 'package:findjob/data/model/job_list_model.dart';

class MyJobListPageStates {}

class JobListInitialState extends MyJobListPageStates {}

class JobListLoadingState extends MyJobListPageStates {}

class JobListLoadedState extends MyJobListPageStates {
  final MyJobListModel myJobListModel;
  JobListLoadedState(this.myJobListModel);
}

class JobListErrorState extends MyJobListPageStates {
  final String error;
  JobListErrorState(this.error);
}
