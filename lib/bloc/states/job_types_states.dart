import 'package:skillmatch/data/model/jobs_types_model.dart';

class MyJobTypesStates {}

class JobTypesLoadingState extends MyJobTypesStates {}

class JobTypesInitialState extends MyJobTypesStates {}

class JobTypesLoadedState extends MyJobTypesStates {
  final MyjobTypesModel myjobTypesModel;
  JobTypesLoadedState({
    required this.myjobTypesModel,
  });
}

class JobTypesErrorState extends MyJobTypesStates {
  final String error;

  JobTypesErrorState({
    required this.error,
  });
}
