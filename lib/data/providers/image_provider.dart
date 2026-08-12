import 'package:image_picker/image_picker.dart';

class MyImageProvider {
  Future<XFile> getImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        throw Exception('You must select an image!');
      }
      return image;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
