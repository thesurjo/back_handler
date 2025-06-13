import 'package:back_handler/back_handler.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    void listener() => _onFormChanged();
    _nameController.addListener(listener);
    _emailController.addListener(listener);
    _messageController.addListener(listener);
  }

  void _onFormChanged() {
    setState(() {
      _hasUnsavedChanges = _nameController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _messageController.text.isNotEmpty;
    });
  }

  Future<bool?> _showUnsavedChangesDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
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
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _hasUnsavedChanges = false);
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
    setState(() => _hasUnsavedChanges = false);
  }

  @override
  Widget build(BuildContext context) {
    return BackHandler.wrap(
      customCallback: _hasUnsavedChanges
          ? (context, closeCallback) async {
              final shouldDiscard = await _showUnsavedChangesDialog();
              if (shouldDiscard == true) Navigator.of(context).pop();
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
              if (_hasUnsavedChanges) _buildUnsavedChangesWarning(),
              const Text(
                'Contact Form',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFormField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter your email';
                  if (!value!.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFormField(
                controller: _messageController,
                label: 'Message',
                icon: Icons.message,
                maxLines: 4,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a message' : null,
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

  Widget _buildUnsavedChangesWarning() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
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
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
