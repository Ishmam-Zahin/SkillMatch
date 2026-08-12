import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findjob/bloc/events/user_event.dart';
import 'package:findjob/bloc/states/user_state.dart';
import 'package:findjob/data/repository/auth_user_repository.dart';

class AuthUserBloc extends Bloc<UserEvent, UserState> {
  final AuthUserRepository _authUserRepository;

  AuthUserBloc(this._authUserRepository) : super(NonAuthenticateUserState()) {
    on<LoginEvent>((event, emitter) async {
      emit(LoadingUserSate());

      try {
        final authUser =
            await _authUserRepository.getAuthUser(event.email, event.password);

        emit(AuthenticateUserSate(authUser));
      } catch (e) {
        emit(AuthUserErrorState(e.toString()));
      }
    });

    on<LogoutEvent>((event, emitter) {
      emit(NonAuthenticateUserState());
    });

    on<CreateUserEvent>((event, emitter) async {
      emit(CreateLoadingUserState());

      try {
        final authUser = await _authUserRepository.createAuthUser(
          name: event.name,
          email: event.email,
          password: event.password,
          phone: event.phone,
          address: event.address,
          image: event.image,
        );

        emit(AuthenticateUserSate(authUser));
      } catch (e) {
        emit(CreateAuthUserErrorState(e.toString()));
      }
    });
  }
}
