/// A Flutter plugin for handling back button presses with customizable double-tap to exit functionality.
///
/// This library provides a comprehensive solution for managing back button behavior in Flutter
/// applications. It includes features such as:
/// * Double-tap to exit functionality
/// * Customizable toast messages and time frames
/// * Support for custom dialogs and bottom sheets
/// * Flexible callback system for custom handling
///
/// See also:
///  * [BackHandler], the main class that provides static methods for back button handling
///  * [BackHandlerWidget], a widget wrapper for easier implementation
///  * [BackHandlerWidgets], a collection of predefined widget builders
library;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

// SECTION: Type Definitions
// -----------------------------------------------------------------------------

/// A function type for building custom widgets in response to back button presses.
///
/// Used by [BackHandler] and [BackHandlerWidget] to create custom UI elements
/// when handling back button events.
///
/// Parameters:
///  * [context] - The build context
///  * [closeCallback] - A callback to close/dismiss the widget
///
/// See also:
///  * [BackHandlerWidgets], which provides predefined implementations
typedef BackHandlerWidgetBuilder =
    Widget Function(BuildContext context, VoidCallback closeCallback);

/// A function type for custom back button press handling.
///
/// Used to implement custom logic when the back button is pressed.
///
/// Parameters:
///  * [context] - The build context
///  * [closeCallback] - A callback to close/dismiss any shown UI elements
///
/// See also:
///  * [BackHandler.customCallback], which uses this type
///  * [BackHandlerWidgets.customSnackbar], which provides an example implementation
typedef BackHandlerCallback =
    Future<void> Function(BuildContext context, VoidCallback closeCallback);

// SECTION: Core Back Handler
// -----------------------------------------------------------------------------

/// The main class that handles back button functionality with double-tap to exit.
///
/// This class provides several static methods and properties to configure and handle
/// back button presses in a Flutter application. It supports:
///
/// 1. Double-tap to exit functionality
/// 2. Customizable toast messages
/// 3. Configurable time frame between taps
/// 4. Custom widget builders for dialogs/sheets
/// 5. Custom callback handlers
///
/// Example usage:
/// ```dart
/// BackHandler.wrap(
///   child: MyApp(),
///   toastMessage: 'Press back again to exit',
///   exitTimeFrame: Duration(seconds: 2),
/// )
/// ```
///
/// See also:
///  * [BackHandlerWidget], which provides a widget-based implementation
///  * [BackHandlerWidgets], which provides predefined widget builders
class BackHandler {
  // SUBSECTION: Private Fields
  // ---------------------------------------------------------------------------

  /// The method channel for platform-specific implementations
  static const MethodChannel _channel = MethodChannel('back_handler');

  /// Tracks the timestamp of the last back button press
  static DateTime? _lastBackPressed;

  /// The message to show when back button is pressed
  static String _toastMessage = 'Press back again to exit';

  /// The time frame within which the second back press should occur
  static Duration _exitTimeFrame = const Duration(seconds: 2);

  /// Custom widget builder for showing UI on back press
  static BackHandlerWidgetBuilder? _customWidgetBuilder;

  /// Custom callback for handling back press
  static BackHandlerCallback? _customCallback;

  /// Whether to show the default toast message
  static bool _showDefaultToast = true;

  // SUBSECTION: Configuration Methods
  // ---------------------------------------------------------------------------

  /// Sets a custom message to show when back button is pressed.
  ///
  /// This message will be shown in both the toast and snackbar (if enabled).
  ///
  /// Example:
  /// ```dart
  /// BackHandler.setToastMessage('Tap back again to leave');
  /// ```
  static void setToastMessage(String message) {
    _toastMessage = message;
  }

  /// Sets the time frame within which the second back press should occur.
  ///
  /// The default time frame is 2 seconds. If the second back press occurs after
  /// this time frame, the counter resets.
  ///
  /// Example:
  /// ```dart
  /// BackHandler.setExitTimeFrame(Duration(seconds: 3));
  /// ```
  static void setExitTimeFrame(Duration duration) {
    _exitTimeFrame = duration;
  }

  /// Sets a custom widget builder for creating UI when back is pressed.
  ///
  /// When set, this builder takes precedence over the default toast message.
  /// Setting this to null reverts to the default behavior.
  ///
  /// See also:
  ///  * [BackHandlerWidgets], which provides predefined builders
  ///
  /// Example:
  /// ```dart
  /// BackHandler.setCustomWidgetBuilder(
  ///   BackHandlerWidgets.confirmationDialog()
  /// );
  /// ```
  static void setCustomWidgetBuilder(BackHandlerWidgetBuilder? builder) {
    _customWidgetBuilder = builder;
    _showDefaultToast = builder == null;
  }

  /// Sets a custom callback for handling back button presses.
  ///
  /// When set, this callback takes highest precedence in the handling chain.
  /// Setting this to null reverts to the default behavior.
  ///
  /// Example:
  /// ```dart
  /// BackHandler.setCustomCallback((context, close) async {
  ///   // Custom handling logic
  /// });
  /// ```
  static void setCustomCallback(BackHandlerCallback? callback) {
    _customCallback = callback;
    _showDefaultToast = callback == null;
  }

  /// Enables or disables the default toast message behavior.
  ///
  /// This can be used to suppress the default toast/snackbar even when no
  /// custom handler is set.
  ///
  /// Example:
  /// ```dart
  /// BackHandler.setShowDefaultToast(false);
  /// ```
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

  // SUBSECTION: UI Methods
  // ---------------------------------------------------------------------------

  /// Shows default toast and snackbar with the configured message.
  ///
  /// This method displays feedback to the user that they need to press back
  /// again to exit. It shows:
  /// - A native Android toast (on Android devices)
  /// - A Material snackbar (on all platforms)
  ///
  /// The message and duration are controlled by [_toastMessage] and [_exitTimeFrame].
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

  /// Shows a custom dialog in response to back button press.
  ///
  /// This method is typically used by the predefined widget builders in
  /// [BackHandlerWidgets], but can also be used directly for custom dialogs.
  ///
  /// Parameters:
  ///  * [context] - The build context
  ///  * [builder] - A function that builds the dialog content
  ///
  /// The builder is provided with a close callback that will properly dismiss
  /// the dialog when called.
  ///
  /// See also:
  ///  * [BackHandlerWidgets.confirmationDialog], which uses this method
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

  /// Shows a custom bottom sheet in response to back button press.
  ///
  /// This method is typically used by the predefined widget builders in
  /// [BackHandlerWidgets], but can also be used directly for custom sheets.
  ///
  /// Parameters:
  ///  * [context] - The build context
  ///  * [builder] - A function that builds the bottom sheet content
  ///
  /// The builder is provided with a close callback that will properly dismiss
  /// the bottom sheet when called.
  ///
  /// See also:
  ///  * [BackHandlerWidgets.customBottomSheet], which uses this method
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

  // SUBSECTION: Core Functionality
  // ---------------------------------------------------------------------------

  /// Handles back button press events with double-tap to exit functionality.
  ///
  /// This is the core method that implements the back button handling logic:
  /// 1. On first press, shows feedback and starts the timer
  /// 2. On second press within [_exitTimeFrame], allows the app to exit
  /// 3. If the time frame expires, resets to initial state
  ///
  /// Parameters:
  ///  * [context] - The build context
  ///  * [customWidgetBuilder] - Optional override for widget builder
  ///  * [customCallback] - Optional override for callback
  ///  * [showDefaultToast] - Optional override for toast visibility
  ///
  /// Returns:
  ///  * `true` if the app should exit (second press within time frame)
  ///  * `false` if the app should not exit (first press or custom handling)
  ///
  /// See also:
  ///  * [wrap], which uses this method to handle back button presses
  ///  * [BackHandlerWidget], which provides a widget-based interface to this method
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

  /// Wraps a widget with back button handling functionality.
  ///
  /// This is the main entry point for using BackHandler in your app. It provides
  /// a simple way to add back button handling to any widget in your app.
  ///
  /// Parameters:
  ///  * [child] - The widget to wrap with back button handling
  ///  * [toastMessage] - Optional custom message to show on back press
  ///  * [exitTimeFrame] - Optional custom time frame for double-tap
  ///  * [customWidgetBuilder] - Optional custom widget builder
  ///  * [customCallback] - Optional custom callback
  ///  * [showDefaultToast] - Optional control for toast visibility
  ///
  /// Example:
  /// ```dart
  /// BackHandler.wrap(
  ///   child: MaterialApp(
  ///     home: MyHomePage(),
  ///   ),
  ///   toastMessage: 'Press back again to exit',
  ///   exitTimeFrame: Duration(seconds: 2),
  /// )
  /// ```
  ///
  /// See also:
  ///  * [BackHandlerWidget], which provides a class-based alternative
  ///  * [handleBackPress], which implements the core functionality
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

// SECTION: Widget Implementation
// -----------------------------------------------------------------------------

/// A StatelessWidget that provides back button handling functionality.
///
/// This widget provides a class-based alternative to [BackHandler.wrap] for adding
/// back button handling to your app. It offers the same functionality but with a
/// more traditional widget-based API.
///
/// Features:
/// * Double-tap to exit functionality
/// * Customizable toast messages
/// * Configurable time frame
/// * Support for custom dialogs and callbacks
///
/// Example:
/// ```dart
/// BackHandlerWidget(
///   child: MaterialApp(
///     home: MyHomePage(),
///   ),
///   toastMessage: 'Press back again to exit',
///   exitTimeFrame: Duration(seconds: 2),
/// )
/// ```
///
/// See also:
///  * [BackHandler.wrap], which provides a functional alternative
///  * [BackHandlerWidgets], which provides predefined widget builders
class BackHandlerWidget extends StatelessWidget {
  /// The widget to wrap with back button handling
  final Widget child;

  /// The message to show when back is pressed
  final String toastMessage;

  /// The time frame for double-tap detection
  final Duration exitTimeFrame;

  /// Optional custom widget builder for back press UI
  final BackHandlerWidgetBuilder? customWidgetBuilder;

  /// Optional custom callback for back press handling
  final BackHandlerCallback? customCallback;

  /// Whether to show the default toast message
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

// SECTION: Predefined Widgets
// -----------------------------------------------------------------------------

/// A collection of predefined widget builders for common back handling scenarios.
///
/// This class provides ready-to-use implementations of common UI patterns for
/// back button handling:
/// * Confirmation dialogs
/// * Bottom sheets
/// * Custom snackbars
///
/// All widgets are customizable through their parameters and follow Material Design
/// guidelines for consistency.
///
/// Example:
/// ```dart
/// BackHandler.wrap(
///   child: MyApp(),
///   customWidgetBuilder: BackHandlerWidgets.confirmationDialog(
///     title: 'Exit App?',
///     message: 'Are you sure you want to exit?',
///   ),
/// )
/// ```
///
/// See also:
///  * [BackHandlerWidgetBuilder], the type these methods return
///  * [BackHandler.showCustomDialog], used by these implementations
class BackHandlerWidgets {
  /// Creates a Material Design confirmation dialog for exit confirmation.
  ///
  /// This dialog follows Material Design guidelines and provides:
  /// * Customizable title and message
  /// * Confirm and cancel actions
  /// * Automatic handling of exit action
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

  /// Creates a beautifully designed bottom sheet for exit confirmation.
  ///
  /// This bottom sheet provides a more interactive and modern approach to exit
  /// confirmation with:
  /// * Custom icon with theme-aware coloring
  /// * Title and message with proper typography
  /// * Styled buttons for stay/exit actions
  /// * Proper elevation and animations
  ///
  /// Example:
  /// ```dart
  /// BackHandler.wrap(
  ///   child: MyApp(),
  ///   customWidgetBuilder: BackHandlerWidgets.customBottomSheet(
  ///     title: 'Leaving so soon?',
  ///     message: 'We hope to see you again!',
  ///     icon: Icons.waving_hand,
  ///   ),
  /// )
  /// ```
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

  /// Creates a custom overlay-based snackbar for a more refined experience.
  ///
  /// Unlike the default snackbar, this implementation:
  /// * Uses an overlay for better positioning
  /// * Provides a close button for manual dismissal
  /// * Has a sleek, modern design with rounded corners
  /// * Supports auto-dismiss with customizable duration
  /// * Works consistently across all platforms
  ///
  /// Example:
  /// ```dart
  /// BackHandler.wrap(
  ///   child: MyApp(),
  ///   customCallback: BackHandlerWidgets.customSnackbar(
  ///     message: 'Tap back again to leave',
  ///     duration: Duration(seconds: 3),
  ///   ),
  /// )
  /// ```
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
