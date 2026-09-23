import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atmabdulbaridanny/routes/app_routes.dart';
import 'package:atmabdulbaridanny/utils/app_log.dart';

class AppLoader {
  // Singleton pattern
  static final AppLoader _instance = AppLoader._internal();
  factory AppLoader() => _instance;
  AppLoader._internal();

  OverlayEntry? _overlayEntry;
  var context = rootNavigatorKey.currentContext;

  /// Shows the un-dismissible loader overlay
  void show({String message = 'Loading...'}) {
    try {
      if (_overlayEntry != null) return;
      if (context == null) return;

      _overlayEntry = OverlayEntry(
        builder: (context) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Material(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      // Insert the overlay into the screen stack
      Overlay.of(context!).insert(_overlayEntry!);
    } catch (e) {
      errorLog("Failed to show loader", e);
    }
  }

  /// Hides the loader when the task is complete
  void hide() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      errorLog("Failed to hide loader", e);
    }
  }
}
