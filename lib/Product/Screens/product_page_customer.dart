import 'package:balink_mobile/Product/Screens/add_product_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balink_mobile/Product/Models/product_model.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'product_detail_page.dart';
import 'package:balink_mobile/Product/Widgets/filter.dart';

class ProductPageCustomer extends StatefulWidget {
  const ProductPageCustomer({super.key});

  @override
  State<ProductPageCustomer> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPageCustomer> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 1000000;
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  void _filterProducts() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesQuery = product.fields.name
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());

        final matchesPrice = product.fields.price >= _minPrice &&
            product.fields.price <= _maxPrice;

        return matchesQuery && matchesPrice;
      }).toList();
    });
  }

  void _updateFilter(String query, double minPrice, double maxPrice) {
    setState(() {
      _searchQuery = query;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _filterProducts();
    });
  }

  void _resetFilter() {
    setState(() {
      _searchQuery = '';
      _minPrice = 0;
      _maxPrice = 1000000;
      _filteredProducts = _allProducts;
    });
  }

  Future<void> _refreshProducts(CookieRequest request) async {
    final products = await fetchProducts(request);
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Vehicle Marketplace',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          // Add Product Button in the AppBar
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              ).then((_) {
                // Refresh products after returning from AddProductPage
                _refreshProducts(request);
              });
            },
            tooltip: 'Add New Product',
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(request),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FilterWidget(
                      onApply: _updateFilter,
                      onReset: _resetFilter,
                    ),
                  ),
                ],
              ),
            ),

            FutureBuilder<List<Product>>(
              future: fetchProducts(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }

                // Initialize products on first load
                if (_allProducts.isEmpty) {
                  _allProducts = snapshot.data!;
                  _filteredProducts = _allProducts;
                }

                if (_filteredProducts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 100,
                            color: colorScheme.secondary,
                          ),
                          Text(
                            'No products found',
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                _animationController.forward(from: 0);

                return SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final product = _filteredProducts[index];
                        return FadeTransition(
                          opacity: _animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.9, end: 1.0).animate(_animation),
                            child: _buildProductCard(context, product),
                          ),
                        );
                      },
                      childCount: _filteredProducts.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductPage(),
            ),
          ).then((_) {
            // Refresh products after returning from AddProductPage
            _refreshProducts(request);
          });
        },
        backgroundColor: colorScheme.primary,
        tooltip: 'Add New Product',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
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
              builder: (context) => ProductDetailPage(product: product),
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
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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
                                text: "${product.fields.kmDriven.toStringAsFixed(0)} km",
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
                                  content: Text('Added ${product.fields.name} to cart'),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                                content: Text('Added ${product.fields.name} to favorites'),
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