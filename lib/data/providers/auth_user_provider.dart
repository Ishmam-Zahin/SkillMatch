import 'package:skillmatch/data/model/auth_user.dart';
import 'package:skillmatch/data/model/skill_matching.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AuthUserProvider {
  MyAuthUser _toModel(User user) {
    final metadata = user.userMetadata ?? <String, dynamic>{};
    return MyAuthUser(
      userId: user.id,
      mail: user.email ?? '',
      userName: metadata['name'] as String? ?? '',
      address: metadata['address'] as String? ?? '',
      phone: metadata['phone'] as String? ?? '',
      imageUrl: metadata['image_url'] as String? ?? '',
      skills: normalizeSkills(metadata['skills']),
    );
  }

  Future<MyAuthUser> getUser(String email, String password) async {
    try {
      final AuthResponse response = await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      return _toModel(response.user!);
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
    required List<String> skills,
  }) async {
    try {
      String imagePath =
          'user_images/$email-${DateTime.now().millisecondsSinceEpoch}.png';
      final imageByte = await image.readAsBytes();
      await Supabase.instance.client.storage
          .from('freelance_app_bucket')
          .uploadBinary(imagePath, imageByte);

      final String imagePublicUrl = Supabase.instance.client.storage
          .from('freelance_app_bucket')
          .getPublicUrl(imagePath);

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'address': address,
          'image_url': imagePublicUrl,
          'skills': skills,
        },
      );

      return MyAuthUser(
        userId: response.user!.id,
        mail: email,
        userName: name,
        address: address,
        phone: phone,
        imageUrl: imagePublicUrl,
        skills: skills,
      );
    } on AuthException catch (e) {
      return Future.error(e.message);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<MyAuthUser> updateSkills(List<String> skills) async {
    try {
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'skills': skills}),
      );
      return _toModel(response.user!);
    } on AuthException catch (e) {
      return Future.error(e.message);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
