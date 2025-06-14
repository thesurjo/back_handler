# back_handler

A Flutter plugin that provides double-tap back button functionality to exit the app with customizable toast messages, custom widgets, and flexible callbacks.

## Features

- **Double-tap to exit**: Prevents accidental app closure by requiring two back button presses
- **Customizable# back_handler

A Flutter plugin that provides double-tap back button functionality to exit the app with customizable toast messages.

## Features

### Core Features
- **Double-tap to exit**: Prevents accidental app closure with configurable double-tap behavior
- **Cross-platform**: Works seamlessly on both Android and iOS devices
- **Multiple implementation styles**: Choose between widget-based or functional approaches
- **Flexible configuration**: Global and per-instance settings

### UI Components
- **Toast Messages**: Native Android toasts with iOS-compatible snackbar fallback
- **Material Dialogs**: Customizable confirmation dialogs
- **Bottom Sheets**: Beautiful material design bottom sheets
- **Custom Snackbars**: Overlay-based notifications with custom styling

### Customization Options
- **Messages**: Fully customizable text for all UI components
- **Time Frame**: Adjustable duration between back presses (default: 2 seconds)
- **UI Builders**: Create completely custom UI components
- **Callbacks**: Implement custom logic for back button handling
- **Theming**: Components follow Material Design and respect app theme

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  back_handler: <latest_version>
```

Then run:

```bash
flutter pub get
```

## Installation

Add to your package's `pubspec.yaml`:

```yaml
dependencies:
  back_handler: <latest_version>
```

Then run:

```bash
flutter pub get
```

## Usage

### 1. Widget-Based Implementation (Recommended)

Use `BackHandlerWidget` for a clean, declarative approach:

```dart
import 'package:back_handler/back_handler.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BackHandlerWidget(
        toastMessage: 'Press back again to exit',
        exitTimeFrame: const Duration(seconds: 2),
        // Optional custom UI
        customWidgetBuilder: BackHandlerWidgets.confirmationDialog(
          title: 'Exit App?',
          message: 'Are you sure you want to exit?',
        ),
        child: MyHomePage(),
      ),
    );
  }
}
```

### 2. Functional Implementation

Use `BackHandler.wrap()` for a functional approach:

```dart
import 'package:back_handler/back_handler.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BackHandler.wrap(
        child: MyHomePage(),
        toastMessage: 'Press back again to exit',
        exitTimeFrame: const Duration(seconds: 2),
        // Optional custom handling
        customCallback: (context, close) async {
          bool? shouldExit = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Exit?'),
              content: Text('Do you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Exit'),
                ),
              ],
            ),
          );
          if (shouldExit == true) SystemNavigator.pop();
        },
      ),
    );
  }
}
```

### 3. Predefined UI Components

The package includes several ready-to-use UI components:

```dart
// Confirmation Dialog
BackHandler.wrap(
  child: MyApp(),
  customWidgetBuilder: BackHandlerWidgets.confirmationDialog(
    title: 'Exit App',
    message: 'Are you sure you want to exit?',
    confirmText: 'Exit',
    cancelText: 'Cancel',
  ),
);

// Bottom Sheet
BackHandler.wrap(
  child: MyApp(),
  customWidgetBuilder: BackHandlerWidgets.customBottomSheet(
    title: 'Exit App?',
    message: 'Press back again to exit',
    icon: Icons.exit_to_app,
  ),
);

// Custom Snackbar
BackHandler.wrap(
  child: MyApp(),
  customCallback: BackHandlerWidgets.customSnackbar(
    message: 'Tap back again to exit',
    duration: Duration(seconds: 2),
  ),
);
```

### 4. Global Configuration

Configure default behavior for your entire app:

```dart
void main() {
  // Set global defaults
  BackHandler.setToastMessage('Please press back again to exit');
  BackHandler.setExitTimeFrame(const Duration(seconds: 2));
  BackHandler.setCustomWidgetBuilder(BackHandlerWidgets.confirmationDialog());
  BackHandler.setShowDefaultToast(false);
  
  runApp(MyApp());
}
```

## API Reference

### BackHandlerWidget

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | Widget | required | Widget to wrap with back handling |
| `toastMessage` | String | 'Press back again to exit' | Custom exit message |
| `exitTimeFrame` | Duration | 2 seconds | Time between presses |
| `customWidgetBuilder` | BackHandlerWidgetBuilder? | null | Custom UI builder |
| `customCallback` | BackHandlerCallback? | null | Custom logic handler |
| `showDefaultToast` | bool | true | Show default toast |

### BackHandler

#### Static Configuration Methods

| Method | Description |
|--------|-------------|
| `setToastMessage(String)` | Set global toast message |
| `setExitTimeFrame(Duration)` | Set global time frame |
| `setCustomWidgetBuilder(BackHandlerWidgetBuilder?)` | Set global UI builder |
| `setCustomCallback(BackHandlerCallback?)` | Set global callback |
| `setShowDefaultToast(bool)` | Control toast visibility |

#### UI Methods

| Method | Description |
|--------|-------------|
| `showCustomDialog()` | Show custom dialog |
| `showCustomBottomSheet()` | Show custom bottom sheet |
| `wrap()` | Wrap widget with back handling |

### BackHandlerWidgets

| Component | Description |
|-----------|-------------|
| `confirmationDialog()` | Material confirmation dialog |
| `customBottomSheet()` | Styled bottom sheet |
| `customSnackbar()` | Overlay-based snackbar |

## Technical Details

### How It Works

1. **First Back Press**
   - Shows configured feedback (toast/dialog/sheet)
   - Starts exit time frame timer
   - Registers timestamp of press

2. **Second Back Press**
   - If within time frame: Exits app
   - If after time frame: Resets to first press behavior

3. **Custom Handling**
   - Priority order: Callback → Widget → Toast
   - Each handler can implement custom logic
   - Support for async operations

### Platform Behavior

| Feature | Android | iOS |
|---------|---------|-----|
| Toast Messages | Native Android Toast | Material Snackbar |
| Exit Action | SystemNavigator.pop() | SystemNavigator.pop() |
| UI Components | Full support | Full support |
| Animations | Material Design | Material Design |

## Advanced Usage

### Form Protection

```dart
BackHandler.wrap(
  child: MyForm(),
  customCallback: (context, close) async {
    if (formHasChanges) {
      bool? discard = await showDiscardDialog(context);
      if (discard == true) SystemNavigator.pop();
    } else {
      SystemNavigator.pop();
    }
  },
);
```

### Custom UI Integration

```dart
BackHandler.wrap(
  child: MyApp(),
  customWidgetBuilder: (context, close) => MyCustomExitDialog(
    onCancel: close,
    onConfirm: () {
      close();
      SystemNavigator.pop();
    },
  ),
);
```

## Example App

The [example app](example/) demonstrates:
- All implementation methods
- Predefined UI components
- Custom UI integration
- Form protection
- Global configuration
- Platform-specific behavior

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for details on:
- Code style
- Development process
- Submitting pull requests

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📘 [Documentation](https://pub.dev/documentation/back_handler/latest/)
- 🐛 [Issue Tracker](https://github.com/thesurjo/back_handler/issues)
- 💬 [Discussions](https://github.com/thesurjo/back_handler/discussions)