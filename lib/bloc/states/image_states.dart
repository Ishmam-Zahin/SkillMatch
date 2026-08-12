import 'package:image_picker/image_picker.dart';

class MyImageStates {}

class ImageInitialState extends MyImageStates {}

class ImageLoadingState extends MyImageStates {}

class ImageLoadedState extends MyImageStates {
  final XFile image;
  ImageLoadedState(this.image);
}

class ImageErrorSate extends MyImageStates {
  final String error;
  ImageErrorSate(this.error);
}
