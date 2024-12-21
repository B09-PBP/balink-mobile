import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:balink_mobile/article/screen/article_detail_page.dart';
import 'package:balink_mobile/article/screen/article_form.dart';
import 'package:balink_mobile/article/models/article_model.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'edit_form.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleAdminPage extends StatefulWidget {
  final bool isAdmin;

  const ArticleAdminPage({Key? key, this.isAdmin = true}) : super(key: key);

  @override
  State<ArticleAdminPage> createState() => _ArticleAdminPageState();
}

class _ArticleAdminPageState extends State<ArticleAdminPage> {
  List<Article>? articles;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

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
      final response = await request.get('http://127.0.0.1:8000/article/json/');
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

  // Function to create article tile with consistent size
  Widget _buildArticleTile(String title, String url) {
    return GestureDetector(
      onTap: () {
        launch(url); // Navigates to the link when tapped
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: double.infinity, // Ensure the container takes full width
        decoration: BoxDecoration(
          color: Colors.blue[50], // Biru muda
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1, // Limit text to a single line
          overflow: TextOverflow.ellipsis, // Add ellipsis when text overflows
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        backgroundColor: Colors.blueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Image.asset(
                  'assets/article.png',
                  height: 25,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Explore Our Latest Articles',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 33, 33, 33),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Guide your tour with these knowledge!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (articles == null || articles!.isEmpty)
                const Center(
                  child: Text(
                    'No articles available.',
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                )
              else
                ListView.builder(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: articles!.length,
                  itemBuilder: (_, index) {
                    final article = articles![index];
                    return GestureDetector(
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
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                    article.fields.image,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 250,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(Icons.broken_image,
                                            size: 50, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    article.fields.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    article.fields.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (widget.isAdmin)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Color(0xFFFFC107)),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditArticle(
                                                article: article,
                                              ),
                                            ),
                                          );
                                          if (result != null) {
                                            fetchArticles();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
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
                                                              context, false),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      child: const Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              ) ??
                                              false;

                                          if (confirm) {
                                            final request =
                                                context.read<CookieRequest>();
                                            try {
                                              await request.post(
                                                'http://127.0.0.1:8000/article/delete/${article.pk}/',
                                                {},
                                              );
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text("Article deleted"),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Failed to delete article"),
                                                    backgroundColor: Colors.red,
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
                                  ),
                              ],
                            ),
                            // "Read more" label
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: GestureDetector(
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
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Read more',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Did You Know?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '“Bali isn’t just an island, it’s a gateway to countless adventures and cultural treasures. At BaLink, we believe every journey through Bali unveils a new story waiting to be discovered.”',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    const url = 'https://maps.app.goo.gl/kfZPeRu7nzBXYgU56';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    width: double
                        .infinity, // Pastikan tombol mengambil lebar penuh
                    decoration: BoxDecoration(
                      color: Colors.red, // Merah
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Our Location in Gmaps',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[900], // Biru tua
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Other Articles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          _buildArticleTile(
                            '15 Destinasi Instagrammable di Bali',
                            'https://www.indonesia.travel/id/id/ide-liburan/15-destinasi-instagrammable-di-bali-yang-harus-sobat-pesona-kunjungi.html',
                          ),
                          _buildArticleTile(
                            '10 Objek Wisata Terbaik di Bali',
                            'https://www.tripadvisor.co.id/Attractions-g294226-Activities-Bali.html',
                          ),
                          _buildArticleTile(
                            '15+ Rekomendasi Tempat Liburan Seru di Pulau Bali',
                            'https://www.cimbniaga.co.id/id/inspirasi/gayahidup/rekomendasi-tempat-wisata-alam-dan-budaya-di-pulau-bali',
                          ),
                          _buildArticleTile(
                            'Top 30 Tempat Wisata di Bali yang Tak Boleh Dilewatkan',
                            'https://id.trip.com/guide/activity/tempat-wisata-di-bali.html',
                          ),
                          _buildArticleTile(
                            '10 Best Things to Do and More in Bali',
                            'https://www.getyourguide.com/-l347/?cmp=ga&ps_theme=ttd&cq_src=google_ads&cq_cmp=15508255885&cq_con=132581187524&cq_term=bali%20top10&cq_med=&cq_plac=&cq_net=g&cq_pos=&cq_plt=gp&campaign_id=15508255885&adgroup_id=132581187524&target_id=kwd-1432321165848&loc_physical_ms=9072593&match_type=b&ad_id=574899113022&keyword=bali%20top10&ad_position=&feed_item_id=&placement=&device=c&partner_id=CD951&gad_source=1&gbraid=0AAAAADmzJCMfR3TgRU8a7SFt9CREmRFNL&gclid=CjwKCAjwyfe4BhAWEiwAkIL8sLqdQBcLdYQWsDByJsrgU5ib8Sn5VPY7EhAqrD0Fr0XwEVS7lcTo7xoCXgsQAvD_BwE',
                          ),
                          _buildArticleTile(
                            'Fun Activities In Bali',
                            'https://www.booking.com/region/id/bali.en.html?aid=377400;label=bali-5VmtKJTi*Vx6LCdfGQXLFAS388490388182:pl:ta:p1:p2:ac:ap:neg:fi:tikwd-308609428065:lp9072593:li:dec:dm:ppccp=UmFuZG9tSVYkc2RlIyh9YdbYVqXDN8zp7PNDFvT66M8;ws=&gbraid=0AAAAAD_Ls1JX1u4e669AzBLVbhxfozgwr&gclid=CjwKCAjwyfe4BhAWEiwAkIL8sGlIzFJWfwqJFv9X1GKTiXl14W24xGclMXaIQ12MsVlM7i3DEzVZ-xoCUXAQAvD_BwE',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArticleForm(isAdmin: true)),
                );
                if (result != null) {
                  fetchArticles();
                }
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
