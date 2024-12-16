import 'package:flutter/material.dart';
import 'package:balink_mobile/bookmarks/models/bookmark_product_models.dart';

class UpdateBookmarkModal extends StatefulWidget {
  final BookmarkModel bookmark;
  final VoidCallback onUpdate;

  const UpdateBookmarkModal({
    super.key,
    required this.bookmark,
    required this.onUpdate,
  });

  @override
  State<UpdateBookmarkModal> createState() => _UpdateBookmarkModalState();
}

class _UpdateBookmarkModalState extends State<UpdateBookmarkModal> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  String _priority = '';

  @override
  void initState() {
    super.initState();
    final fields = widget.bookmark.fields;
    _noteController.text = fields.note;
    _priority = fields.priority;
    _reminderController.text = fields.reminder.toIso8601String().split('T').first;
  }

  Future<void> _submitUpdate() async {
    // Simulate an update API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark updated successfully')),
    );
    widget.onUpdate();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Update Bookmark',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _priority,
            onChanged: (value) => setState(() => _priority = value ?? ''),
            items: const [
              DropdownMenuItem(value: 'H', child: Text('High')),
              DropdownMenuItem(value: 'M', child: Text('Medium')),
              DropdownMenuItem(value: 'L', child: Text('Low')),
            ],
            decoration: const InputDecoration(labelText: 'Priority'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reminderController,
            decoration: const InputDecoration(
              labelText: 'Reminder Date',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitUpdate,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    _reminderController.dispose();
    super.dispose();
  }
}