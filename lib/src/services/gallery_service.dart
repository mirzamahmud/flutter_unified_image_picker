import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service that manages loading images from the device gallery.
///
/// Responsibilities:
/// - Request gallery/photo permissions.
/// - Fetch all image paths via platform channel.
/// - Notify listeners when images are loaded or updated.
class GalleryService {
  /// Platform channel used to communicate with native code for gallery access.
  static const MethodChannel _platform = MethodChannel('app.gallery/images');

  /// Holds the list of image file paths from the gallery.
  ///
  /// Use [ValueListenableBuilder] or other listeners to react to changes.
  final ValueNotifier<List<String>> imagesNotifier = ValueNotifier([]);

  /// Loads gallery images from the device.
  ///
  /// Steps:
  /// 1. Requests gallery permission.
  /// 2. Calls the platform channel method `'getImages'`.
  /// 3. Updates [imagesNotifier] with the retrieved paths.
  /// 4. Handles errors gracefully by logging and clearing the list.
  Future<void> loadGallery() async {
    // Request permission
    final status = await _requestPermission();
    if (!status) return;

    try {
      final List<dynamic> paths = await _platform.invokeMethod('getImages');
      imagesNotifier.value = paths.cast<String>();
    } on PlatformException catch (e) {
      debugPrint("GalleryService: Failed to get images: ${e.message}");
      imagesNotifier.value = [];
    }
  }

  /// Requests permission to access gallery/photos.
  ///
  /// Returns `true` if permission granted, `false` otherwise.
  Future<bool> _requestPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  /// Disposes the [imagesNotifier] to clean up resources.
  void dispose() {
    imagesNotifier.dispose();
  }
}
