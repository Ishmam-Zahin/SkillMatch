import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/events/delete_job_events.dart';
import 'package:skillmatch/bloc/states/delete_job_states.dart';
import 'package:skillmatch/data/repository/home_page_repository.dart';

class DeleteJobBloc extends Bloc<MyDeleteJobEvents, MyDeleteJobStates> {
  final HomePageRepository homePageRepository;
  DeleteJobBloc(this.homePageRepository) : super(DeleteJobInitialState()) {
    on<DeleteJobEvent>((event, emitter) async {
      emit(DeleteJobLoadingState());
      try {
        await homePageRepository.deleteJob(jobId: event.jobId);
        emit(DeleteJobLoadedState());
      } catch (e) {
        emit(DeleteJobErrorSate(error: e.toString()));
      }
    });
  }
}
