# Changelog

All notable changes to the Back Handler plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-08

### 🎉 Initial Release

#### ✨ Features

- **Double-tap to exit functionality**: Implements the classic Android double-tap back button behavior
- **Configurable exit timeframe**: Customizable duration between back presses (default: 2 seconds)
- **Multiple implementation options**:
  - Static wrapper method `BackHandler.wrap()`
  - Stateless widget `BackHandlerWidget`
  - Manual handling with `BackHandler.handleBackPress()`

#### 🎨 Customization Options

- **Custom toast messages**: Set personalized exit confirmation messages
- **Custom widget builders**: Create custom dialogs, bottom sheets, or any widget for first back press
- **Custom callbacks**: Implement completely custom behavior for back press handling
- **Default toast control**: Option to disable built-in toast notifications

#### 🛠️ Built-in Components

- **Cross-platform toast support**: Native Android toast with iOS-compatible SnackBar fallback
- **PopScope integration**: Seamlessly works with Flutter's navigation system
- **Memory management**: Automatic cleanup and proper widget lifecycle handling

#### 📦 Predefined Widgets

- **Confirmation Dialog** (`BackHandlerWidgets.confirmationDialog()`):
  - Customizable title, message, and button text
  - Clean AlertDialog implementation
  
- **Custom Bottom Sheet** (`BackHandlerWidgets.customBottomSheet()`):
  - Material Design bottom sheet with icon and actions
  - Themed buttons with exit confirmation
  
- **Custom Snackbar** (`BackHandlerWidgets.customSnackbar()`):
  - Overlay-based notification system
  - Auto-dismiss functionality with close button

#### 🔧 Configuration Methods

- `setToastMessage(String)` - Customize exit message
- `setExitTimeFrame(Duration)` - Configure double-tap timing
- `setCustomWidgetBuilder()` - Set global custom widget
- `setCustomCallback()` - Set global custom callback
- `setShowDefaultToast(bool)` - Control default toast behavior

#### 📱 Platform Support

- **Android**: Full native toast support via MethodChannel
- **iOS**: SnackBar-based notifications for consistent UX
- **Error handling**: Graceful fallbacks for platform-specific features

#### 🎯 Usage Examples

- Simple wrapper implementation
- Widget-based integration
- Custom dialog configurations
- Advanced callback implementations

#### 🔒 Safety Features

- Context mounting checks to prevent memory leaks
- Null-safe implementation throughout
- Proper disposal of overlay entries and timers
- Exception handling for platform channel communications

### 📋 API Reference

#### Classes
- `BackHandler` - Main static class with configuration and handling methods
- `BackHandlerWidget` - Stateless widget wrapper
- `BackHandlerWidgets` - Predefined widget builders

#### Typedefs
- `BackHandlerWidgetBuilder` - Custom widget builder signature
- `BackHandlerCallback` - Custom callback function signature

#### Methods
- Static configuration methods for global settings
- Instance-specific parameter overrides
- Utility methods for dialogs and bottom sheets

---

### 🚀 Getting Started

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  back_handler: ^1.0.0
```

Basic usage:
```dart
BackHandler.wrap(
  child: YourWidget(),
  toastMessage: "Press back again to exit",
)
```

For more examples and advanced usage, see the [README.md](README.md) file.

---

**Full Changelog**: Initial release v1.0.0