
import 'flutter_unified_image_picker_platform_interface.dart';

class FlutterUnifiedImagePicker {
  Future<String?> getPlatformVersion() {
    return FlutterUnifiedImagePickerPlatform.instance.getPlatformVersion();
  }
}
