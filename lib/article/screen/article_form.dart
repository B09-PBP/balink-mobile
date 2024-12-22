import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import '../models/article_model.dart';

class ArticleForm extends StatefulWidget {
  final Article? article;
  final bool isAdmin;

  const ArticleForm({
    super.key,
    this.article,
    this.isAdmin = true,
  });

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
                prefixIcon: Icon(
                  Icons.title,
                  color: Colors.blue, // Blue color for title
                ),
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
                prefixIcon: Icon(
                  Icons.text_fields,
                  color: Color.fromARGB(255, 142, 204, 255), // Light blue for content
                ),
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
                prefixIcon: Icon(
                  Icons.image,
                  color: Colors.blue, // Blue color for main image
                ),
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
                prefixIcon: Icon(
                  Icons.image,
                  color: Color.fromARGB(255, 142, 204, 255), // Light blue for additional image 1
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _image2Controller,
              decoration: const InputDecoration(
                labelText: 'Additional Image 2 URL',
                prefixIcon: Icon(
                  Icons.image,
                  color: Color.fromARGB(255, 142, 204, 255), // Light blue for additional image 2
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _image3Controller,
              decoration: const InputDecoration(
                labelText: 'Additional Image 3 URL',
                prefixIcon: Icon(
                  Icons.image,
                  color: Color.fromARGB(255, 142, 204, 255), // Light blue for additional image 3
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await request.postJson(
                    "https://nevin-thang-balink.pbp.cs.ui.ac.id/article/create-flutter/",
                    jsonEncode({
                      'user': 1, 
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
                          const SnackBar(content: Text("Article updated successfully!")),
                        );
                        Navigator.pop(context, true); 
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Failed to save article: ${response['message'] ?? 'Unknown error'}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Error saving article. Check your endpoint URL or response format."),
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
