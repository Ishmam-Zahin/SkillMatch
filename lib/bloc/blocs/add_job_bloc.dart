import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findjob/bloc/events/add_job_events.dart';
import 'package:findjob/bloc/states/add_job_states.dart';
import 'package:findjob/data/repository/home_page_repository.dart';

class AddJobBloc extends Bloc<MyAddJobEvents, MyAddJobStates> {
  final HomePageRepository homePageRepository;
  AddJobBloc({required this.homePageRepository}) : super(AddJobInitialState()) {
    on<UploadJobEvent>((event, emitter) async {
      try {
        emit(AddJobLoadingState());
        await homePageRepository.uploadJob(
          title: event.title,
          dsc: event.dsc,
          deadlineDate: event.deadlineDate,
          userId: event.userId,
          typeId: event.typeId,
        );
        emit(AddJobLoadedState(message: 'Job Uploaded Successfully!'));
      } catch (e) {
        emit(
          AddJobErrorState(
            error: e.toString(),
          ),
        );
      }
    });
  }
}
