import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worklance/bloc/events/delete_job_events.dart';
import 'package:worklance/bloc/states/delete_job_states.dart';
import 'package:worklance/data/repository/home_page_repository.dart';

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
