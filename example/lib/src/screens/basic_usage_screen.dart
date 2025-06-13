import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class BasicUsageScreen extends StatelessWidget {
  const BasicUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Basic Usage'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: PageHeader(
            icon: Icons.touch_app,
            title: 'Double Tap to Exit',
            subtitle: 'This uses the default BackHandler behavior\nwith toast and snackbar messages',
          ),
        ),
      ),
    );
  }
}
