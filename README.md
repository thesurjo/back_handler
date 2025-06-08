# back_handler

A Flutter plugin that provides double-tap back button functionality to exit the app with customizable toast messages, custom widgets, and flexible callbacks.

## Features

- **Double-tap to exit**: Prevents accidental app closure by requiring two back button presses
- **Customizable# back_handler

A Flutter plugin that provides double-tap back button functionality to exit the app with customizable toast messages.

## Features

- **Double-tap to exit**: Prevents accidental app closure by requiring two back button presses
- **Customizable toast message**: Set your own message that appears on first back press
- **Configurable time frame**: Adjust how long users have between presses (default: 2 seconds)
- **Cross-platform support**: Works on both Android and iOS
- **Easy integration**: Simple widget wrapper or manual implementation options

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  back_handler: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Method 1: Using BackHandlerWidget (Recommended)

Wrap your main content with `BackHandlerWidget`:

```dart
import 'package:back_handler/back_handler.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BackHandlerWidget(
        toastMessage: 'Press back again to exit',
        exitTimeFrame: Duration(seconds: 2),
        child: Scaffold(
          appBar: AppBar(title: Text('My App')),
          body: Center(child: Text('Hello World')),
        ),
      ),
    );
  }
}
```

### Method 2: Using WillPopScope with BackHandler

For more control, use `WillPopScope` with `BackHandler.handleBackPress()`:

```dart
import 'package:back_handler/back_handler.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Customize settings before handling
        BackHandler.setToastMessage('Tap back again to close');
        BackHandler.setExitTimeFrame(Duration(seconds: 3));
        
        return await BackHandler.handleBackPress(context);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: Center(child: Text('Content here')),
      ),
    );
  }
}
```

### Method 3: Global Configuration

Set global defaults that apply throughout your app:

```dart
void main() {
  // Set global defaults
  BackHandler.setToastMessage('Please press back again to exit');
  BackHandler.setExitTimeFrame(Duration(seconds: 2));
  
  runApp(MyApp());
}
```

## API Reference

### BackHandlerWidget

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | Widget | required | The widget to wrap with back handling |
| `toastMessage` | String | 'Press back again to exit' | Message shown on first back press |
| `exitTimeFrame` | Duration | Duration(seconds: 2) | Time between presses to exit |

### BackHandler Static Methods

| Method | Description |
|--------|-------------|
| `setToastMessage(String message)` | Sets the toast message globally |
| `setExitTimeFrame(Duration duration)` | Sets the exit time frame globally |
| `handleBackPress(BuildContext context)` | Handles back press logic, returns `Future<bool>` |

## How It Works

1. **First back press**: Shows toast message and starts timer
2. **Second back press** (within time frame): Exits the app
3. **Timeout**: If second press doesn't come within the time frame, the process resets

## Platform-Specific Behavior

- **Android**: Shows native Toast message + SnackBar
- **iOS**: Shows SnackBar only (iOS doesn't have native toast)

## Example

Check out the [example app](example/) for a complete demonstration including:
- Custom toast messages
- Dynamic message updates
- Different usage patterns
- Visual feedback and instructions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Issues and Feedback

Please file issues and feedback on the [GitHub repository](https://github.com/thesurjo/back_handler/issues).