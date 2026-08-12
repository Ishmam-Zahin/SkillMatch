import 'package:findjob/data/model/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AuthUserProvider {
  Future<MyAuthUser> getUser(String email, String password) async {
    try {
      final AuthResponse response =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return MyAuthUser(
        userId: response.user!.id,
        mail: response.user!.email!,
        userName: response.user!.userMetadata!['name'],
        address: response.user!.userMetadata!['address'],
        phone: response.user!.userMetadata!['phone'],
        imageUrl: response.user!.userMetadata!['image_url'],
      );
    } on AuthException catch (e) {
      return Future.error(e.message);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<MyAuthUser> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required XFile image,
  }) async {
    try {
      String imagePath =
          'user_images/$email-${DateTime.now().millisecondsSinceEpoch}.png';
      final imageByte = await image.readAsBytes();
      await Supabase.instance.client.storage
          .from('freelance_app_bucket')
          .uploadBinary(
            imagePath,
            imageByte,
          );

      final String imagePublicUrl = Supabase.instance.client.storage
          .from('freelance_app_bucket')
          .getPublicUrl(imagePath);

      final response = await Supabase.instance.client.auth
          .signUp(email: email, password: password, data: {
        'name': name,
        'phone': phone,
        'address': address,
        'image_url': imagePublicUrl,
      });

      return MyAuthUser(
        userId: response.user!.id,
        mail: email,
        userName: name,
        address: address,
        phone: phone,
        imageUrl: imagePublicUrl,
      );
    } on AuthException catch (e) {
      return Future.error(e.message);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
