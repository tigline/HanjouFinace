import 'package:image_picker/image_picker.dart';

enum ProfileDocumentImageSource { camera, gallery }

abstract class ProfileDocumentImagePicker {
  Future<String?> pick(ProfileDocumentImageSource source);
}

class DeviceProfileDocumentImagePicker implements ProfileDocumentImagePicker {
  DeviceProfileDocumentImagePicker([ImagePicker? imagePicker])
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<String?> pick(ProfileDocumentImageSource source) async {
    final xFile = await _imagePicker.pickImage(
      source: source == ProfileDocumentImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1800,
    );
    return xFile?.path;
  }
}
