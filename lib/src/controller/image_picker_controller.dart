import 'package:flutter/foundation.dart';
import 'package:flutter_unified_image_picker/src/services/bottom_sheet_service.dart';
import 'package:flutter_unified_image_picker/src/services/camera_service.dart';
import 'package:flutter_unified_image_picker/src/services/gallery_service.dart';

/// Controller that manages camera, gallery, and bottom sheet for the
/// image picker plugin.
///
/// This class acts as the central point to coordinate the services:
/// - [CameraService] for camera preview, capture, switching lenses, and flash.
/// - [GalleryService] for fetching images from the device gallery.
/// - [BottomSheetService] for managing the draggable gallery sheet.
class ImagePickerController extends ChangeNotifier {
  /// Camera service that handles camera initialization, preview, capture,
  /// switching lenses, and flash.
  final CameraService cameraService = CameraService();

  /// Gallery service that fetches device images and notifies listeners
  /// when the gallery is loaded or updated.
  final GalleryService galleryService = GalleryService();

  /// Bottom sheet service that manages the draggable sheet state
  /// and animations.
  final BottomSheetService bottomSheetService = BottomSheetService();

  /// Initializes both the camera and gallery services.
  ///
  /// - Calls [CameraService.initCamera] to initialize the camera.
  /// - Adds listeners to camera readiness and flash state to notify
  ///   UI updates.
  /// - Calls [GalleryService.loadGallery] to load device images.
  /// - Adds listener to gallery images to notify UI updates.
  Future<void> initialize() async {
    await cameraService.initCamera();
    cameraService.isReady.addListener(notifyListeners);
    cameraService.isFlashOn.addListener(notifyListeners);

    await galleryService.loadGallery();
    galleryService.imagesNotifier.addListener(notifyListeners);
  }

  /// Captures an image using the current camera.
  ///
  /// Returns the file path of the captured image, or `null` if capture failed.
  Future<String?> captureImage() async {
    return await cameraService.captureImage();
  }

  /// Switches to the next available camera lens.
  ///
  /// Supports front/back/other available lenses.
  Future<void> switchCamera() async {
    await cameraService.switchCamera();
  }

  /// Toggles the camera flash between on and off.
  void toggleFlash() {
    cameraService.toggleFlash();
  }

  /// Opens or closes the draggable bottom sheet.
  ///
  /// Also notifies listeners so UI can update immediately.
  void toggleBottomSheet() {
    bottomSheetService.toggleSheet();
    notifyListeners();
  }

  /// Disposes all services and cleans up listeners.
  @override
  void dispose() {
    cameraService.dispose();
    galleryService.dispose();
    bottomSheetService.dispose();
    super.dispose();
  }
}
