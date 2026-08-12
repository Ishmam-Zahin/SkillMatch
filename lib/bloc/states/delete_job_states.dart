class MyDeleteJobStates {}

class DeleteJobInitialState extends MyDeleteJobStates {}

class DeleteJobLoadingState extends MyDeleteJobStates {}

class DeleteJobLoadedState extends MyDeleteJobStates {}

class DeleteJobErrorSate extends MyDeleteJobStates {
  final String error;
  DeleteJobErrorSate({required this.error});
}
