import 'package:image_picker/image_picker.dart';

sealed class UserEvent {}

final class LoginEvent extends UserEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}

final class LogoutEvent extends UserEvent {}

final class CreateUserEvent extends UserEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String address;
  final XFile image;
  final List<String> skills;

  CreateUserEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.image,
    required this.skills,
  });
}

final class UpdateUserSkillsEvent extends UserEvent {
  final List<String> skills;

  UpdateUserSkillsEvent({required this.skills});
}
