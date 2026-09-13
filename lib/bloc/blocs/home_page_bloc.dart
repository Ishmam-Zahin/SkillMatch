import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/events/home_page_events.dart';
import 'package:skillmatch/bloc/states/home_page_states.dart';

class HomePageBloc extends Bloc<MyHomePageEvents, MyHomePageStates> {
  HomePageBloc() : super(ShowJobListPageState()) {
    on<LoadProfilePageEvent>((event, emitter) {
      emit(ShowProfilePageState());
    });

    on<LoadJobListPageEvent>((event, emitter) {
      emit(ShowJobListPageState());
    });

    on<LoadSearchPageEvent>((event, emitter) {
      emit(ShowSearchPageState());
    });

    on<LoadAddJobPageEvent>((event, emitter) {
      emit(ShowAddJobPageState());
    });
  }
}
