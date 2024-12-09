import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import '../models/article_model.dart';

class ArticleForm extends StatefulWidget {
  final Article? article;
  final bool isAdmin;

  const ArticleForm({
    Key? key,
    this.article,
    this.isAdmin = true,
  }) : super(key: key);

  @override
  State<ArticleForm> createState() => _ArticleFormState();
}

class _ArticleFormState extends State<ArticleForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _imageController;
  late TextEditingController _image1Controller;
  late TextEditingController _image2Controller;
  late TextEditingController _image3Controller;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.article?.fields.title ?? '');
    _contentController =
        TextEditingController(text: widget.article?.fields.content ?? '');
    _imageController =
        TextEditingController(text: widget.article?.fields.image ?? '');
    _image1Controller =
        TextEditingController(text: widget.article?.fields.image1 ?? '');
    _image2Controller =
        TextEditingController(text: widget.article?.fields.image2 ?? '');
    _image3Controller =
        TextEditingController(text: widget.article?.fields.image3 ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article == null ? 'Add Article' : 'Edit Article'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter content' : null,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(
                labelText: 'Main Image URL',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter main image URL' : null,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _image1Controller,
              decoration: const InputDecoration(
                labelText: 'Additional Image 1 URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _image2Controller,
              decoration: const InputDecoration(
                labelText: 'Additional Image 2 URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _image3Controller,
              decoration: const InputDecoration(
                labelText: 'Additional Image 3 URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Make sure your URL is correct and ends with /
                  final response = await request.postJson(
                    "http://127.0.0.1:8000/article/create-flutter/", // Update this URL to match your Django endpoint
                    jsonEncode({
                      'user': 1, // Add user ID
                      'title': _titleController.text,
                      'content': _contentController.text,
                      'image': _imageController.text,
                      'image1': _image1Controller.text,
                      'image2': _image2Controller.text,
                      'image3': _image3Controller.text,
                    }),
                  );

                  if (context.mounted) {
                    try {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Article saved successfully!")),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Error saving article. Check your endpoint URL."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Save Article'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();
    _image1Controller.dispose();
    _image2Controller.dispose();
    _image3Controller.dispose();
    super.dispose();
  }
}
