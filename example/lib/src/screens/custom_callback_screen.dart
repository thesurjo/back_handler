import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/page_header.dart';

class CustomCallbackScreen extends StatefulWidget {
  const CustomCallbackScreen({super.key});

  @override
  State<CustomCallbackScreen> createState() => _CustomCallbackScreenState();
}

class _CustomCallbackScreenState extends State<CustomCallbackScreen> {
  int _backPressCount = 0;

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Persistent User!'),
        content: const Text(
          'You\'ve pressed back 3 times! You really want to leave, don\'t you?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _backPressCount = 0);
            },
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _handleBackPress() {
    setState(() => _backPressCount++);
    if (_backPressCount >= 3) {
      _showExitDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Back pressed $_backPressCount time(s). Press ${3 - _backPressCount} more times to see something special!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      customCallback: (context, closeCallback) async => _handleBackPress(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Callback'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageHeader(
                icon: Icons.code,
                title: 'Custom Back Press Logic',
                subtitle: 'Back press count: $_backPressCount\n\nPress back multiple times to see custom callback behavior!',
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
