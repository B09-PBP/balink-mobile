import 'package:flutter/material.dart';
import '../models/article_model.dart';
import 'article_form.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;
  final bool isAdmin;

  const ArticleDetailPage({
    Key? key,
    required this.article,
    this.isAdmin = true,
  }) : super(key: key);

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article Detail"),
        backgroundColor: Colors.blueAccent,
        actions: widget.isAdmin
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleForm(article: widget.article),
                      ),
                    );
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and content sections
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.article.fields.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.article.fields.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.article.fields.content,
              style: const TextStyle(
                fontSize: 16.0,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            if (widget.article.fields.image1.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Image.network(widget.article.fields.image1),
            ],
            if (widget.article.fields.image2.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Image.network(widget.article.fields.image2),
            ],
            if (widget.article.fields.image3.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Image.network(widget.article.fields.image3),
            ],
            const SizedBox(height: 24.0),
            const Divider(),
            const SizedBox(height: 12.0),
            const Text(
              "Comments",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            // Comments Section
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 2,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      _comments[index],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),
            // Input Field for Comments
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: "Write your comment...",
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) => _addComment(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
