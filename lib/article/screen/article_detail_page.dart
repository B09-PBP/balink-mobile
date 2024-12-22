import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../../Product/Models/product_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../../Product/Screens/product_detail_page.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;
  final bool isAdmin;

  const ArticleDetailPage({
    super.key,
    required this.article,
    this.isAdmin = true,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final PageController _pageController = PageController();
  List<Map<String, String>> _comments = [];
  List<Product> _products = [];
  bool _isLoadingProducts = true;
  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _fetchComments();
  }

  List<String> get _validImages {
    List<String> images = [widget.article.fields.image];
    if ((widget.article.fields.image1 ?? '').isNotEmpty) {
      images.add(widget.article.fields.image1!);
    }
    if ((widget.article.fields.image2 ?? '').isNotEmpty) {
      images.add(widget.article.fields.image2!);
    }
    if ((widget.article.fields.image3 ?? '').isNotEmpty) {
      images.add(widget.article.fields.image3!);
    }
    return images;
  }

  // Custom Image Slider Widget
  Widget _buildImageSlider(List<String> images, double screenWidth) {
    return Stack(
      children: [
        Container(
          height: screenWidth * 9 / 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
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
        ),
        // Modern page indicators
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _fetchComments() async {
    final request = context.read<CookieRequest>();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await request.get(
        'http://127.0.0.1:8000/article/${widget.article.pk}/comments/',
      );

      if (response['success'] == true) {
        setState(() {
          // Ensure each comment is converted to Map<String, String>
          _comments = (response['comments'] as List)
              .map((comment) => {
                    "user": comment['user'].toString(),
                    "text": comment['text'].toString(),
                  })
              .toList();
        });
      } else {
        _showErrorDialog(response['error']);
      }
    } catch (e) {
      _showErrorDialog("Failed to fetch comments: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addComment() async {
    final request = context.read<CookieRequest>();

    if (_commentController.text.trim().isNotEmpty) {
      final commentText = _commentController.text.trim();

      try {
        final response = await request.post(
          'http://127.0.0.1:8000/article/${widget.article.pk}/add_comment/',
          {
            'comment_text': commentText,
          },
        );

        if (response['success'] == true) {
          _commentController.clear();
          _fetchComments(); // Refresh comments after adding
        } else {
          _showErrorDialog(response['error']);
        }
      } catch (e) {
        _showErrorDialog("An error occurred: $e");
      }
    } else {
      _showErrorDialog("Comment text cannot be empty.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<List<Product>> fetchProducts(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/product/json/');
      if (response == null) throw Exception('Failed to load products');

      return (response as List).map((d) => Product.fromJson(d)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
      return [];
    }
  }

  Future<void> _loadProducts() async {
    final request = context.read<CookieRequest>();
    try {
      final products = await fetchProducts(request);
      setState(() {
        // Take only the first 4 products
        _products = products.take(4).toList();
        _isLoadingProducts = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading products: $e');
      }
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            // Navigate to the ProductDetailPage when the card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product, allProducts: const [],),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      product.fields.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Product Details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name
                      Text(
                        product.fields.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Vehicle Details and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                _buildDetailChip(
                                  icon: Icons.calendar_month,
                                  text: product.fields.year.toStringAsFixed(0),
                                ),
                                _buildDetailChip(
                                  icon: Icons.speed,
                                  text:
                                      "${product.fields.kmDriven.toStringAsFixed(0)} km",
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Rp. ${product.fields.price.toStringAsFixed(2)}/day",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Added ${product.fields.name} to cart'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade700,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const FittedBox(
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.favorite_border, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Added ${product.fields.name} to favorites'),
                                  backgroundColor: Colors.pink,
                                ),
                              );
                            },
                            color: Colors.pink.shade300,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method for creating detail chips
  Widget _buildDetailChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _validImages;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate number of grid columns dynamically
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Article Detail",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue[400],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlider(images, screenWidth),
            const SizedBox(height: 16.0),
            Center(
              child: Text(
                widget.article.fields.title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 20.0 : 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.article.fields.content,
              style: TextStyle(
                fontSize: isSmallScreen ? 14.0 : 16.0,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24.0),

            // Comments Section
            const SizedBox(height: 12.0),
            const Text(
              "Comments",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            _isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : _comments.isEmpty
                ? const Center(
              child: Text(
                "No comments yet. Be the first to comment!",
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              separatorBuilder: (context, index) =>
              const SizedBox(height: 6.0),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 2,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child:
                      Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      comment['text'] ?? 'No content',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    subtitle: Text(
                      'by ${comment['user'] ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12.0),

            // Comment Input Field
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
                    icon:
                    const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),

            const Divider(),

            // Related Products Section
            const SizedBox(height: 12.0),
            const Text(
              "Related Products",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            if (_isLoadingProducts)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_products.isEmpty)
              const Center(
                child: Text("No related products found"),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isSmallScreen ? 1 : 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(context, _products[index]);
                },
              ),

            const SizedBox(height: 24.0),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
