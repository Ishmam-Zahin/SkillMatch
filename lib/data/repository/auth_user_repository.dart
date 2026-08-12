import 'package:findjob/data/model/auth_user.dart';
import 'package:findjob/data/providers/auth_user_provider.dart';
import 'package:findjob/data/providers/image_provider.dart';
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
  });
  Future<XFile> loadImage();
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
  }) async {
    try {
      return await authUserProvider.createUser(
          name: name,
          email: email,
          password: password,
          phone: phone,
          address: address,
          image: image);
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
}
