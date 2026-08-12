class MyAddJobStates {}

class AddJobInitialState extends MyAddJobStates {}

class AddJobLoadingState extends MyAddJobStates {}

class AddJobLoadedState extends MyAddJobStates {
  final String message;
  AddJobLoadedState({required this.message});
}

class AddJobErrorState extends MyAddJobStates {
  final String error;
  AddJobErrorState({required this.error});
}
