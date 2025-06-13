import 'package:flutter/material.dart';
import 'src/config/constants.dart';
import 'src/config/router.dart';
import 'src/config/theme.dart';
import 'src/screens/home_screen.dart';

void main() {
  runApp(const BackHandlerExampleApp());
}

class BackHandlerExampleApp extends StatelessWidget {
  const BackHandlerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      onGenerateRoute: AppRouter.generateRoute,
      home: const HomeScreen(),
    );
  }
}
