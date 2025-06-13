import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      customWidgetBuilder: BackHandlerWidgets.confirmationDialog(
        title: 'Are you leaving?',
        message: 'You\'re about to exit this amazing page!',
        confirmText: 'Yes, Exit',
        cancelText: 'No, Stay',
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dialog Example'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: PageHeader(
            icon: Icons.help_outline,
            title: 'Confirmation Dialog',
            subtitle: 'Press back to see a beautifully designed confirmation dialog',
            iconColor: Colors.orange,
          ),
        ),
      ),
    );
  }
}
