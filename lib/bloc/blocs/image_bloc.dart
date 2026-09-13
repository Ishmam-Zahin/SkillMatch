import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/events/image_events.dart';
import 'package:skillmatch/bloc/states/image_states.dart';
import 'package:skillmatch/data/repository/auth_user_repository.dart';

class MyImageBloc extends Bloc<MyImageEvents, MyImageStates> {
  final AuthUserRepository _authUserRepository;

  MyImageBloc(this._authUserRepository) : super(ImageInitialState()) {
    on<LoadImageEvent>((event, emitter) async {
      emit(ImageLoadingState());
      try {
        emit(ImageLoadedState(await _authUserRepository.loadImage()));
      } catch (e) {
        emit(ImageErrorSate(e.toString()));
      }
    });
  }
}
