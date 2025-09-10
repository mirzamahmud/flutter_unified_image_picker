import 'package:flutter/material.dart';

/// Service that manages the state and animation of a draggable bottom sheet.
///
/// This includes:
/// - Tracking whether the sheet is expanded or collapsed.
/// - Animating the sheet to expand/collapse programmatically.
/// - Listening to manual drags and updating [isExpanded] automatically.
class BottomSheetService {
  /// Indicates whether the sheet is currently expanded.
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);

  /// Controller for the DraggableScrollableSheet to manage size and animations.
  final DraggableScrollableController dragController =
      DraggableScrollableController();

  /// Constructor adds a listener to the [dragController] to detect manual drags.
  ///
  /// Automatically updates [isExpanded] when the user drags the sheet
  /// beyond a threshold (0.5 by default).
  BottomSheetService() {
    dragController.addListener(() {
      if (dragController.size >= 0.5 && !isExpanded.value) {
        isExpanded.value = true;
      } else if (dragController.size < 0.5 && isExpanded.value) {
        isExpanded.value = false;
      }
    });
  }

  /// Toggles the sheet open or closed.
  ///
  /// Expands if collapsed, collapses if expanded.
  void toggleSheet() {
    if (isExpanded.value) {
      collapseSheet();
    } else {
      expandSheet();
    }
  }

  /// Expands the sheet to a given size (default 0.85).
  ///
  /// Also sets [isExpanded] to true.
  void expandSheet({double size = 0.85}) {
    isExpanded.value = true;
    dragController.animateTo(
      size,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Collapses the sheet to a given size (default 0.25).
  ///
  /// Also sets [isExpanded] to false.
  void collapseSheet({double size = 0.25}) {
    isExpanded.value = false;
    dragController.animateTo(
      size,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Disposes of the [ValueNotifier] and [DraggableScrollableController].
  ///
  /// Should be called when this service is no longer needed.
  void dispose() {
    isExpanded.dispose();
    dragController.dispose();
  }
}
