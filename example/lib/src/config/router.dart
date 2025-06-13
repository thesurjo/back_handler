import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../screens/basic_usage_screen.dart';
import '../screens/bottom_sheet_screen.dart';
import '../screens/custom_callback_screen.dart';
import '../screens/custom_message_screen.dart';
import '../screens/dialog_screen.dart';
import '../screens/form_screen.dart';
import '../screens/widget_builder_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.basicUsage:
        return MaterialPageRoute(builder: (_) => const BasicUsageScreen());
      case AppConstants.customMessage:
        return MaterialPageRoute(builder: (_) => const CustomMessageScreen());
      case AppConstants.dialog:
        return MaterialPageRoute(builder: (_) => const DialogScreen());
      case AppConstants.bottomSheet:
        return MaterialPageRoute(builder: (_) => const BottomSheetScreen());
      case AppConstants.customCallback:
        return MaterialPageRoute(builder: (_) => const CustomCallbackScreen());
      case AppConstants.widgetBuilder:
        return MaterialPageRoute(builder: (_) => const WidgetBuilderScreen());
      case AppConstants.form:
        return MaterialPageRoute(builder: (_) => const FormScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
