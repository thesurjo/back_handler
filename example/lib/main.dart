import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import your BackHandler plugin here
// import 'package:your_back_handler_plugin/back_handler.dart';

void main() {
  runApp(const BackHandlerExampleApp());
}

class BackHandlerExampleApp extends StatelessWidget {
  const BackHandlerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BackHandler Plugin Examples',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MainMenuPage(),
    );
  }
}

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

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
            _buildExampleCard(
              context,
              'Basic Usage',
              'Simple double-tap to exit with default toast',
              Icons.touch_app,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BasicUsageExample(),
                ),
              ),
            ),
            _buildExampleCard(
              context,
              'Custom Message',
              'Customize the exit confirmation message',
              Icons.message,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomMessageExample(),
                ),
              ),
            ),
            _buildExampleCard(
              context,
              'Confirmation Dialog',
              'Show a confirmation dialog instead of toast',
              Icons.help_outline,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DialogExample()),
              ),
            ),
            _buildExampleCard(
              context,
              'Custom Bottom Sheet',
              'Beautiful bottom sheet for exit confirmation',
              Icons.swipe_up,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomSheetExample(),
                ),
              ),
            ),
            _buildExampleCard(
              context,
              'Custom Callback',
              'Handle back press with custom logic',
              Icons.code,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CustomCallbackExample(),
                ),
              ),
            ),
            _buildExampleCard(
              context,
              'Widget Builder',
              'Use BackHandlerWidget for cleaner code',
              Icons.widgets,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WidgetBuilderExample(),
                ),
              ),
            ),
            _buildExampleCard(
              context,
              'Form with Unsaved Changes',
              'Conditional back handling based on form state',
              Icons.edit_note,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormExample()),
              ),
            ),
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
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Example 1: Basic Usage
class BasicUsageExample extends StatelessWidget {
  const BasicUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Basic Usage'),
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, size: 64, color: Colors.blue),
              SizedBox(height: 24),
              Text(
                'Press back button twice to exit',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'This uses the default BackHandler behavior\nwith toast and snackbar messages',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 2: Custom Message
class CustomMessageExample extends StatefulWidget {
  const CustomMessageExample({super.key});

  @override
  State<CustomMessageExample> createState() => _CustomMessageExampleState();
}

class _CustomMessageExampleState extends State<CustomMessageExample> {
  final TextEditingController _controller = TextEditingController();
  String _currentMessage = 'Tap back again to leave this awesome app!';

  @override
  void initState() {
    super.initState();
    _controller.text = _currentMessage;
  }

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      toastMessage: _currentMessage,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Message'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.message, size: 64, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Customize Your Exit Message',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Exit Message',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your custom message',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentMessage = _controller.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message updated! Try pressing back now.'),
                    ),
                  );
                },
                child: const Text('Update Message'),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Current Message:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentMessage,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Example 3: Confirmation Dialog
class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.help_outline, size: 64, color: Colors.orange),
              SizedBox(height: 24),
              Text(
                'Press back to see confirmation dialog',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'This shows a custom AlertDialog\ninstead of the default toast',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 4: Bottom Sheet
class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      customWidgetBuilder: BackHandlerWidgets.customBottomSheet(
        title: 'Hold on!',
        message:
            'Are you sure you want to leave? This page has some cool content!',
        icon: Icons.favorite,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bottom Sheet Example'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.swipe_up, size: 64, color: Colors.purple),
              const SizedBox(height: 24),
              const Text(
                'Beautiful Bottom Sheet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Press back to see a custom bottom sheet with smooth animations and beautiful design.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Add some content to make the page more interesting
              ...List.generate(
                10,
                (index) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Sample Content ${index + 1}'),
                    subtitle: Text(
                      'This is some sample content for demonstration',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 5: Custom Callback
class CustomCallbackExample extends StatefulWidget {
  const CustomCallbackExample({super.key});

  @override
  State<CustomCallbackExample> createState() => _CustomCallbackExampleState();
}

class _CustomCallbackExampleState extends State<CustomCallbackExample> {
  int _backPressCount = 0;

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      customCallback: (context, closeCallback) async {
        setState(() {
          _backPressCount++;
        });

        if (_backPressCount >= 3) {
          // Show special message after 3 back presses
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
                    setState(() {
                      _backPressCount = 0;
                    });
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
        } else {
          // Show snackbar with count
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Back pressed $_backPressCount time(s). Press ${3 - _backPressCount} more times to see something special!',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Callback'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.code, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Custom Back Press Logic',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Back press count: $_backPressCount',
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Press back multiple times to see\ncustom callback behavior!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 6: Widget Builder Usage
class WidgetBuilderExample extends StatelessWidget {
  const WidgetBuilderExample({super.key});

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
          TextButton(onPressed: closeCallback, child: const Text('Cancel')),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.widgets, size: 64, color: Colors.teal),
              SizedBox(height: 24),
              Text(
                'BackHandlerWidget Usage',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'This example uses BackHandlerWidget\ninstead of BackHandler.wrap() for cleaner code structure.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Exit time frame: 3 seconds',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example 7: Form with Unsaved Changes
class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _messageController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges =
          _nameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _messageController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      customCallback: _hasUnsavedChanges
          ? (context, closeCallback) async {
              final shouldDiscard = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Unsaved Changes'),
                  content: const Text(
                    'You have unsaved changes. Do you want to discard them?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Discard'),
                    ),
                  ],
                ),
              );

              if (shouldDiscard == true) {
                Navigator.of(context).pop();
              }
            }
          : null,
      showDefaultToast: !_hasUnsavedChanges,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Example'),
          automaticallyImplyLeading: false,
          actions: [
            if (_hasUnsavedChanges)
              IconButton(
                onPressed: _saveForm,
                icon: const Icon(Icons.save),
                tooltip: 'Save Form',
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_hasUnsavedChanges)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'You have unsaved changes. Back button will show confirmation.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              const Text(
                'Contact Form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  if (!value!.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.message),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearForm,
                      child: const Text('Clear'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _hasUnsavedChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {
      _hasUnsavedChanges = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
