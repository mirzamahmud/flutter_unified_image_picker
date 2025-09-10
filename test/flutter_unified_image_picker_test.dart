import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unified_image_picker/flutter_unified_image_picker.dart';
import 'package:flutter_unified_image_picker/flutter_unified_image_picker_platform_interface.dart';
import 'package:flutter_unified_image_picker/flutter_unified_image_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterUnifiedImagePickerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterUnifiedImagePickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterUnifiedImagePickerPlatform initialPlatform = FlutterUnifiedImagePickerPlatform.instance;

  test('$MethodChannelFlutterUnifiedImagePicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterUnifiedImagePicker>());
  });

  test('getPlatformVersion', () async {
    FlutterUnifiedImagePicker flutterUnifiedImagePickerPlugin = FlutterUnifiedImagePicker();
    MockFlutterUnifiedImagePickerPlatform fakePlatform = MockFlutterUnifiedImagePickerPlatform();
    FlutterUnifiedImagePickerPlatform.instance = fakePlatform;

    expect(await flutterUnifiedImagePickerPlugin.getPlatformVersion(), '42');
  });
}
