import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worklance/bloc/events/job_comments_events.dart';
import 'package:worklance/bloc/states/job_comments_states.dart';
import 'package:worklance/data/repository/home_page_repository.dart';

class JobCommentBloc extends Bloc<MyJobCommentsEvents, MyJobCommentsStates> {
  final HomePageRepository homePageRepository;
  JobCommentBloc({required this.homePageRepository})
    : super(JobCommentsInitialState()) {
    on<LoadCommentsEvent>((event, emitter) async {
      try {
        emit(JobCommentsLoadingState());
        emit(
          JobCommentsLoadedState(
            comments: await homePageRepository.getComments(jobId: event.jobId),
          ),
        );
      } catch (e) {
        emit(JobCommentsErrorState(error: e.toString()));
      }
    });
  }
}
