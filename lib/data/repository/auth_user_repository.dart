import 'package:skillmatch/data/model/auth_user.dart';
import 'package:skillmatch/data/providers/auth_user_provider.dart';
import 'package:skillmatch/data/providers/image_provider.dart';
import 'package:image_picker/image_picker.dart';

abstract class IAuthUserRepository {
  Future<MyAuthUser> getAuthUser(String email, String password);
  Future<MyAuthUser> createAuthUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required XFile image,
    required List<String> skills,
  });
  Future<XFile> loadImage();
  Future<MyAuthUser> updateSkills(List<String> skills);
}

class AuthUserRepository implements IAuthUserRepository {
  final AuthUserProvider authUserProvider;
  final MyImageProvider myImageProvider;
  AuthUserRepository({
    required this.authUserProvider,
    required this.myImageProvider,
  });

  @override
  Future<MyAuthUser> getAuthUser(String email, String password) async {
    try {
      return authUserProvider.getUser(email, password);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<MyAuthUser> createAuthUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required XFile image,
    required List<String> skills,
  }) async {
    try {
      return await authUserProvider.createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        image: image,
        skills: skills,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<XFile> loadImage() async {
    try {
      return await myImageProvider.getImage();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<MyAuthUser> updateSkills(List<String> skills) async {
    try {
      return await authUserProvider.updateSkills(skills);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
