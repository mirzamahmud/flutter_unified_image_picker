import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_unified_image_picker_method_channel.dart';

abstract class FlutterUnifiedImagePickerPlatform extends PlatformInterface {
  /// Constructs a FlutterUnifiedImagePickerPlatform.
  FlutterUnifiedImagePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterUnifiedImagePickerPlatform _instance = MethodChannelFlutterUnifiedImagePicker();

  /// The default instance of [FlutterUnifiedImagePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterUnifiedImagePicker].
  static FlutterUnifiedImagePickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterUnifiedImagePickerPlatform] when
  /// they register themselves.
  static set instance(FlutterUnifiedImagePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
