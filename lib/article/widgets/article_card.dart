import 'package:flutter/material.dart';
import '../models/article_model.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onTap;

  const ArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
    this.isAdmin = true,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            article.fields.image,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          article.fields.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          article.fields.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: onTap,
        trailing: isAdmin
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
