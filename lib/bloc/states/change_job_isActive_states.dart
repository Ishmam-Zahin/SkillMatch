class MyChangeJobIsActiveState {}

class ChangeJobIsActiveInitialState extends MyChangeJobIsActiveState {}

class ChangeJobIsActiveLoadingState extends MyChangeJobIsActiveState {}

class ChangeJobIsActiveLoadedState extends MyChangeJobIsActiveState {}

class ChangeJobIsActiveErrorState extends MyChangeJobIsActiveState {
  String error;
  ChangeJobIsActiveErrorState({required this.error});
}
