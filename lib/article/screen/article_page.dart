import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:balink_mobile/article/screen/article_detail_page.dart';
import 'package:balink_mobile/article/screen/article_form.dart';
import 'package:flutter/material.dart';
import 'package:balink_mobile/article/models/article_model.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ArticlePage extends StatefulWidget {
  final bool isAdmin;

  const ArticlePage({Key? key, this.isAdmin = true}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  Future<List<Article>> fetchArticles() async {
    final request = context.watch<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/article/json/');

    // Convert the response to a string first
    String jsonString = jsonEncode(response);
    return articleFromJson(jsonString);
  }

  final List<Map<String, String>> otherArticles = [
    {
      "title": "15 Destinasi Instagrammable di Bali",
      "url":
          "https://www.indonesia.travel/id/id/ide-liburan/15-destinasi-instagrammable-di-bali-yang-harus-sobat-pesona-kunjungi.html"
    },
    {
      "title": "10 Objek Wisata Terbaik di Bali",
      "url":
          "https://www.tripadvisor.co.id/Attractions-g294226-Activities-Bali.html"
    },
    {
      "title": "15+ Rekomendasi Tempat Liburan Seru di Pulau Bali",
      "url":
          "https://www.cimbniaga.co.id/id/inspirasi/gayahidup/rekomendasi-tempat-wisata-alam-dan-budaya-di-pulau-bali"
    },
    // Add other articles here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder<List<Article>>(
                future: fetchArticles(),
                builder: (context, AsyncSnapshot<List<Article>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No articles available.',
                        style:
                            TextStyle(fontSize: 20, color: Colors.blueAccent),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      final article = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleDetailPage(
                                  article: article,
                                  isAdmin: widget.isAdmin,
                                ),
                              ),
                            );
                          },
                          trailing: widget.isAdmin
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    // Show confirmation dialog
                                    bool confirm = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Article'),
                                            content: const Text(
                                                'Are you sure you want to delete this article?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        ) ??
                                        false;

                                    if (confirm) {
                                      final request = context.read<
                                          CookieRequest>(); // Changed from watch to read
                                      try {
                                        final response = await request.post(
                                          'http://127.0.0.1:8000/article/delete/${article.pk}/',
                                          {},
                                        );

                                        if (context.mounted) {
                                          if (response['status'] == 'success') {
                                            setState(() {
                                              // Refresh the list
                                              fetchArticles();
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Article deleted successfully!"),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Failed to delete article"),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Other Articles',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: otherArticles.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          otherArticles[index]["title"]!,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () async {
                          final url = Uri.parse(otherArticles[index]["url"]!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        trailing: const Icon(Icons.open_in_new),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleForm(isAdmin: true),
                  ),
                );
                if (result != null) {
                  setState(() {}); // Refresh the list after adding new article
                }
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
