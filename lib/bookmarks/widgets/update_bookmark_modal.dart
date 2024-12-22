import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
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
    _noteController.text = widget.bookmark.note;
    _priority = widget.bookmark.priority;
    _reminderController.text = widget.bookmark.reminder.toIso8601String().split('T').first;
  }

  Future<void> _submitUpdate() async {
    final request = context.read<CookieRequest>();
    final url = 'https://nevin-thang-balink.pbp.cs.ui.ac.id/bookmarks/update-bookmark-flutter/${widget.bookmark.id}/';

    // Data yang akan dikirim
    final data = {
      "note": _noteController.text,
      "priority": _priority,
      "reminder": _reminderController.text,
    };

    try {
      final response = await request.post(url, data);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(    // ignore: use_build_context_synchronously
          const SnackBar(content: Text('Bookmark updated successfully')),
        );
        widget.onUpdate();
        Navigator.pop(context);                        // ignore: use_build_context_synchronously
      } else {
        ScaffoldMessenger.of(context).showSnackBar(    // ignore: use_build_context_synchronously
          SnackBar(content: Text('Failed to update bookmark: ${response['message'] ?? ''}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(    // ignore: use_build_context_synchronously
        SnackBar(content: Text('Error updating bookmark: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, 
      child: SingleChildScrollView(
        child: Padding(
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
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reminderController,
                decoration: const InputDecoration(
                  labelText: 'Reminder Date (YYYY-MM-DD)',
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
        ),
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