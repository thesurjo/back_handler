library;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Callback function type for custom widget builders
typedef BackHandlerWidgetBuilder =
    Widget Function(BuildContext context, VoidCallback closeCallback);

/// Callback function type for custom actions
typedef BackHandlerCallback =
    Future<void> Function(BuildContext context, VoidCallback closeCallback);

/// A plugin that handles back button functionality with double-tap to exit
class BackHandler {
  static const MethodChannel _channel = MethodChannel('back_handler');

  static DateTime? _lastBackPressed;
  static String _toastMessage = 'Press back again to exit';
  static Duration _exitTimeFrame = const Duration(seconds: 2);
  static BackHandlerWidgetBuilder? _customWidgetBuilder;
  static BackHandlerCallback? _customCallback;
  static bool _showDefaultToast = true;

  /// Sets the custom toast message
  static void setToastMessage(String message) {
    _toastMessage = message;
  }

  /// Sets the time frame for double tap (default: 2 seconds)
  static void setExitTimeFrame(Duration duration) {
    _exitTimeFrame = duration;
  }

  /// Sets a custom widget builder for first back press
  static void setCustomWidgetBuilder(BackHandlerWidgetBuilder? builder) {
    _customWidgetBuilder = builder;
    _showDefaultToast = builder == null;
  }

  /// Sets a custom callback for first back press
  static void setCustomCallback(BackHandlerCallback? callback) {
    _customCallback = callback;
    _showDefaultToast = callback == null;
  }

  /// Enables or disables default toast message
  static void setShowDefaultToast(bool show) {
    _showDefaultToast = show;
  }

  /// Shows a toast message (Android only)
  static Future<void> _showToast(String message) async {
    try {
      await _channel.invokeMethod('showToast', {'message': message});
    } catch (e) {
      debugPrint('BackHandler: Error showing toast: $e');
    }
  }

  /// Shows default toast and snackbar
  static Future<void> _showDefaultMessage(BuildContext context) async {
    await _showToast(_toastMessage);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_toastMessage),
          duration: _exitTimeFrame,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Shows a popup dialog with custom widget
  static Future<void> showCustomDialog(
    BuildContext context,
    BackHandlerWidgetBuilder builder,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return builder(dialogContext, () => Navigator.of(dialogContext).pop());
      },
    );
  }

  /// Shows a bottom sheet with custom widget
  static Future<void> showCustomBottomSheet(
    BuildContext context,
    BackHandlerWidgetBuilder builder,
  ) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return builder(sheetContext, () => Navigator.of(sheetContext).pop());
      },
    );
  }

  /// Handles the back button press with double-tap functionality
  static Future<bool> handleBackPress(
    BuildContext context, {
    BackHandlerWidgetBuilder? customWidgetBuilder,
    BackHandlerCallback? customCallback,
    bool? showDefaultToast,
  }) async {
    final DateTime now = DateTime.now();

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > _exitTimeFrame) {
      _lastBackPressed = now;

      // Use parameter-specific or global settings
      final widgetBuilder = customWidgetBuilder ?? _customWidgetBuilder;
      final callback = customCallback ?? _customCallback;
      final showToast = showDefaultToast ?? _showDefaultToast;

      // Priority: Custom callback > Custom widget > Default toast
      if (callback != null) {
        await callback(context, () {
          // Close any open dialogs/sheets
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
      } else if (widgetBuilder != null) {
        await showCustomDialog(context, widgetBuilder);
      } else if (showToast) {
        await _showDefaultMessage(context);
      }

      return false; // Don't exit yet
    }

    return true; // Exit the app
  }

  /// Wraps a widget with back button handling
  static Widget wrap({
    required Widget child,
    String? toastMessage,
    Duration? exitTimeFrame,
    BackHandlerWidgetBuilder? customWidgetBuilder,
    BackHandlerCallback? customCallback,
    bool? showDefaultToast,
  }) {
    if (toastMessage != null) setToastMessage(toastMessage);
    if (exitTimeFrame != null) setExitTimeFrame(exitTimeFrame);

    return Builder(
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) return;

            final shouldPop = await handleBackPress(
              context,
              customWidgetBuilder: customWidgetBuilder,
              customCallback: customCallback,
              showDefaultToast: showDefaultToast,
            );

            if (shouldPop && context.mounted) {
              // Exit the app
              SystemNavigator.pop();
            }
          },
          child: child,
        );
      },
    );
  }
}

/// Widget that provides back button handling
class BackHandlerWidget extends StatelessWidget {
  final Widget child;
  final String toastMessage;
  final Duration exitTimeFrame;
  final BackHandlerWidgetBuilder? customWidgetBuilder;
  final BackHandlerCallback? customCallback;
  final bool showDefaultToast;

  const BackHandlerWidget({
    super.key,
    required this.child,
    this.toastMessage = 'Press back again to exit',
    this.exitTimeFrame = const Duration(seconds: 2),
    this.customWidgetBuilder,
    this.customCallback,
    this.showDefaultToast = true,
  });

  @override
  Widget build(BuildContext context) {
    BackHandler.setToastMessage(toastMessage);
    BackHandler.setExitTimeFrame(exitTimeFrame);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final shouldPop = await BackHandler.handleBackPress(
          context,
          customWidgetBuilder: customWidgetBuilder,
          customCallback: customCallback,
          showDefaultToast: showDefaultToast,
        );

        if (shouldPop && context.mounted) {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}

/// Predefined custom widget builders for common use cases
class BackHandlerWidgets {
  /// Creates a simple confirmation dialog
  static BackHandlerWidgetBuilder confirmationDialog({
    String title = 'Exit App',
    String message = 'Are you sure you want to exit?',
    String confirmText = 'Exit',
    String cancelText = 'Cancel',
  }) {
    return (context, closeCallback) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: closeCallback, child: Text(cancelText)),
        TextButton(
          onPressed: () {
            closeCallback();
            // Force exit on confirmation
            SystemNavigator.pop();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }

  /// Creates a custom bottom sheet
  static BackHandlerWidgetBuilder customBottomSheet({
    String title = 'Exit App?',
    String message = 'Press back again to exit the app',
    IconData icon = Icons.exit_to_app,
  }) {
    return (context, closeCallback) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: closeCallback,
                child: const Text('Stay'),
              ),
              ElevatedButton(
                onPressed: () {
                  closeCallback();
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Creates a snackbar-like widget at the bottom
  static BackHandlerCallback customSnackbar({
    String message = 'Press back again to exit',
    Duration duration = const Duration(seconds: 2),
  }) {
    return (context, closeCallback) async {
      final overlay = Overlay.of(context);
      late OverlayEntry overlayEntry;

      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => overlayEntry.remove(),
                    icon: const Icon(Icons.close, color: Colors.white),
                    iconSize: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      // Auto remove after duration
      Timer(duration, () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      });
    };
  }
}
