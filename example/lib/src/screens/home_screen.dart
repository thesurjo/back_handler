import 'package:flutter/material.dart';
import 'package:back_handler/back_handler.dart';
import '../config/constants.dart';
import '../widgets/example_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BackHandler Examples'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildExampleList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.exit_to_app, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'BackHandler Plugin Demo',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore different ways to handle back button presses in your Flutter app',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleList(BuildContext context) {
    final examples = [
      (
        AppConstants.basicUsage,
        'Basic Usage',
        'Simple double-tap to exit with default toast',
        Icons.touch_app
      ),
      (
        AppConstants.customMessage,
        'Custom Message',
        'Customize the exit confirmation message',
        Icons.message
      ),
      (
        AppConstants.dialog,
        'Confirmation Dialog',
        'Show a confirmation dialog instead of toast',
        Icons.help_outline
      ),
      (
        AppConstants.bottomSheet,
        'Custom Bottom Sheet',
        'Beautiful bottom sheet for exit confirmation',
        Icons.swipe_up
      ),
      (
        AppConstants.customCallback,
        'Custom Callback',
        'Handle back press with custom logic',
        Icons.code
      ),
      (
        AppConstants.widgetBuilder,
        'Widget Builder',
        'Use BackHandlerWidget for cleaner code',
        Icons.widgets
      ),
      (
        AppConstants.form,
        'Form with Unsaved Changes',
        'Conditional back handling based on form state',
        Icons.edit_note
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: examples.length,
      itemBuilder: (context, index) {
        final example = examples[index];
        return ExampleCard(
          title: example.$2,
          subtitle: example.$3,
          icon: example.$4,
          onTap: () => Navigator.pushNamed(context, example.$1),
        );
      },
    );
  }
}
