import 'package:flutter/material.dart';

class UpdateBookmarkModal extends StatelessWidget {
  final TextEditingController noteController;
  final TextEditingController priorityController;
  final TextEditingController reminderController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const UpdateBookmarkModal({
    super.key,
    required this.noteController,
    required this.priorityController,
    required this.reminderController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Bookmark'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Note Input
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            // Priority Dropdown
            DropdownButtonFormField<String>(
              value: priorityController.text,
              items: const [
                DropdownMenuItem(value: 'H', child: Text('High')),
                DropdownMenuItem(value: 'M', child: Text('Medium')),
                DropdownMenuItem(value: 'L', child: Text('Low')),
              ],
              onChanged: (value) {
                priorityController.text = value ?? '';
              },
              decoration: const InputDecoration(labelText: 'Priority'),
            ),
            const SizedBox(height: 16),
            // Reminder Input
            TextField(
              controller: reminderController,
              decoration: const InputDecoration(labelText: 'Reminder (YYYY-MM-DD)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        ElevatedButton(onPressed: onSave, child: const Text('Save Changes')),
      ],
    );
  }
}