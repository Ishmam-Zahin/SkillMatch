import 'package:findjob/data/model/auth_user.dart';

class UserState {}

class AuthenticateUserSate extends UserState {
  final MyAuthUser myAuthUser;
  AuthenticateUserSate(this.myAuthUser);
}

class LoadingUserSate extends UserState {}

class CreateLoadingUserState extends UserState {}

class NonAuthenticateUserState extends UserState {}

class AuthUserErrorState extends UserState {
  final String error;
  AuthUserErrorState(this.error);
}

class CreateAuthUserErrorState extends UserState {
  final String error;
  CreateAuthUserErrorState(this.error);
}

class CreateAuthUserSuccessfulState extends UserState {}
