import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_unified_image_picker_platform_interface.dart';

/// An implementation of [FlutterUnifiedImagePickerPlatform] that uses method channels.
class MethodChannelFlutterUnifiedImagePicker extends FlutterUnifiedImagePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_unified_image_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
