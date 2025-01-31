import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:balink_mobile/article/screen/article_detail_page.dart';
import 'package:balink_mobile/article/screen/article_form.dart';
import 'package:balink_mobile/article/models/article_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'edit_form.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleAdminPage extends StatefulWidget {
  final bool isAdmin;

  const ArticleAdminPage({super.key, this.isAdmin = true});

  @override
  State<ArticleAdminPage> createState() => _ArticleAdminPageState();
}

class _ArticleAdminPageState extends State<ArticleAdminPage> {
  List<Article>? articles;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final Color blue400 = const Color.fromRGBO(32, 73, 255, 1); // Bright Blue
  final Color yellow = const Color.fromRGBO(255, 203, 48, 1); // Bright Yellow
  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchArticles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('https://nevin-thang-balink.pbp.cs.ui.ac.id/article/json/');
      String jsonString = jsonEncode(response);
      articles = articleFromJson(jsonString);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Place",
              style: TextStyle(
                color: yellow,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              " to Go ",
              style: TextStyle(
                color: blue400,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Icon(
              Icons.article_rounded,
              color: blue400,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Discover Bali',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 8),
                    const Text(
                      'Curated guides for your next adventure',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        letterSpacing: 0.2,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .slideX(begin: -0.2, end: 0),
                  ],
                ),
              ),
            ),

            if (isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black54,
                  ),
                ),
              )
            else if (articles == null || articles!.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No articles available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final article = articles![index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailPage(
                              article: article,
                              isAdmin: widget.isAdmin,
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                offset: const Offset(0, 8),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  article.fields.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey[100],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 32,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.fields.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      article.fields.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black54,
                                        height: 1.6,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Text(
                                          'Read article',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: Colors.blue.shade400,
                                        ),
                                        const Spacer(),
                                        if (widget.isAdmin) ...[
                                          IconButton(
                                            icon:
                                            const Icon(Icons.edit_outlined),
                                            color: Colors.orange,
                                            onPressed: () async {
                                              final result =
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditArticle(
                                                          article: article),
                                                ),
                                              );
                                              if (result != null) {
                                                fetchArticles();
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline),
                                            color: Colors.red,
                                            onPressed: () async {
                                              bool confirm = await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          'Delete Article'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this article?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  false),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  true),
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.red),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              ) ??
                                                  false;

                                              if (confirm) {
                                                final request = context // ignore: use_build_context_synchronously
                                                    .read<CookieRequest>();
                                                try {
                                                  await request.post(
                                                    'https://nevin-thang-balink.pbp.cs.ui.ac.id/article/delete/${article.pk}/',
                                                    {},
                                                  );
                                                } catch (e) {
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context) // ignore: use_build_context_synchronously
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Article deleted"),
                                                        backgroundColor:
                                                        Colors.green,
                                                      ),
                                                    );
                                                  }
                                                } finally {
                                                  if (mounted) {
                                                    fetchArticles();
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 100 * index))
                            .slideY(begin: 0.1, end: 0),
                      );
                    },
                    childCount: articles!.length,
                  ),
                ),
              ),

            // Quick Links Section
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      offset: const Offset(0, 8),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Links',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: yellow,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildQuickLink(
                          'Find Location',
                          Icons.location_on_outlined,
                          'https://maps.app.goo.gl/kfZPeRu7nzBXYgU56',
                        ),
                        _buildQuickLink(
                          'Top Destinations',
                          Icons.place_outlined,
                          'https://www.tripadvisor.co.id/Attractions-g294226-Activities-Bali.html',
                        ),
                        _buildQuickLink(
                          'Activities',
                          Icons.local_activity_outlined,
                          'https://www.getyourguide.com/-l347/',
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArticleForm(isAdmin: true),
            ),
          );
          if (result != null) {
            fetchArticles();
          }
        },
        backgroundColor: Colors.blue[400],
        child: const Icon(Icons.add),
      ).animate().fadeIn(delay: 1200.ms).scale()
          : null,
    );
  }

  Widget _buildQuickLink(String title, IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.black54,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}