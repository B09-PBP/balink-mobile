import 'package:flutter/material.dart';
import 'article_detail_page.dart';

class ArticlePage extends StatelessWidget {
  // Hardcoded data untuk daftar artikel
  final List<Map<String, String>> articles = [
    {
      'title': 'Exploring Bali',
      'content': 'Discover the best places to visit in Bali...',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Top Beaches in Bali',
      'content': 'Bali is known for its breathtaking beaches...',
      'image': 'https://via.placeholder.com/150',
    },
    {
      'title': 'Cultural Spots to Visit',
      'content': 'Experience the rich culture of Bali through...',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  article['image']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                article['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              subtitle: Text(
                article['content']!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailPage(
                      title: article['title']!,
                      content: article['content']!,
                      image: article['image']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
