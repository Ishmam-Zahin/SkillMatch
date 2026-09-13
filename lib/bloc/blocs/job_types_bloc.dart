import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/events/job_types_events.dart';
import 'package:skillmatch/bloc/states/job_types_states.dart';
import 'package:skillmatch/data/repository/home_page_repository.dart';

class JobTypesBloc extends Bloc<MyJobTypesEvents, MyJobTypesStates> {
  final HomePageRepository homePageRepository;
  JobTypesBloc({
    required this.homePageRepository,
  }) : super(JobTypesInitialState()) {
    on<LoadJobTypesEvent>((event, emitter) async {
      try {
        emit(JobTypesLoadingState());
        emit(
          JobTypesLoadedState(
            myjobTypesModel: await homePageRepository.getJobTypes(),
          ),
        );
      } catch (e) {
        emit(JobTypesErrorState(error: e.toString()));
      }
    });
  }
}
