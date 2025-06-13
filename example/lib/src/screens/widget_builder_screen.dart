import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/page_header.dart';

class WidgetBuilderScreen extends StatelessWidget {
  const WidgetBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackHandlerWidget(
      toastMessage: 'Using BackHandlerWidget for cleaner code!',
      exitTimeFrame: const Duration(seconds: 3),
      customWidgetBuilder: (context, closeCallback) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.widgets, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text('Widget Builder'),
          ],
        ),
        content: const Text(
          'This dialog was created using BackHandlerWidget with a custom builder!',
        ),
        actions: [
          TextButton(
            onPressed: closeCallback,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              closeCallback();
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widget Builder'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: PageHeader(
            icon: Icons.widgets,
            title: 'BackHandlerWidget Usage',
            subtitle: 'This example uses BackHandlerWidget\ninstead of BackHandler.wrap() for cleaner code structure.\n\nExit time frame: 3 seconds',
            iconColor: Colors.teal,
          ),
        ),
      ),
    );
  }
}
