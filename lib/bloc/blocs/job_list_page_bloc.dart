import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worklance/bloc/events/job_list_page_events.dart';
import 'package:worklance/bloc/states/job_list_page_states.dart';
import 'package:worklance/data/repository/home_page_repository.dart';

class JobListPageBloc extends Bloc<MyJobListPageEvents, MyJobListPageStates> {
  final HomePageRepository _homePageRepository;
  JobListPageBloc(this._homePageRepository) : super(JobListLoadingState()) {
    on<LoadJobListEvent>((event, emitter) async {
      try {
        emit(JobListLoadingState());
        emit(
          JobListLoadedState(
            await _homePageRepository.getJobList(
              event.typeId,
              userId: event.userId,
              userSkills: event.userSkills,
            ),
          ),
        );
      } catch (e) {
        emit(JobListErrorState(e.toString()));
      }
    });
  }
}
