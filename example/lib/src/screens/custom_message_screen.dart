import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class CustomMessageScreen extends StatefulWidget {
  const CustomMessageScreen({super.key});

  @override
  State<CustomMessageScreen> createState() => _CustomMessageScreenState();
}

class _CustomMessageScreenState extends State<CustomMessageScreen> {
  final TextEditingController _controller = TextEditingController();
  String _currentMessage = 'Tap back again to leave this awesome app!';

  @override
  void initState() {
    super.initState();
    _controller.text = _currentMessage;
  }

  void _updateMessage() {
    setState(() => _currentMessage = _controller.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message updated! Try pressing back now.')),
    );
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
              const PageHeader(
                icon: Icons.message,
                title: 'Customize Your Exit Message',
                subtitle: 'Set a custom message that appears when users try to exit',
                iconColor: Colors.green,
              ),
              const SizedBox(height: 24),
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
                onPressed: _updateMessage,
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
