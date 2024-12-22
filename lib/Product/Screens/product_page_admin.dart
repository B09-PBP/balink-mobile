import 'package:balink_mobile/Product/Screens/add_product_page.dart';
import 'package:balink_mobile/Product/Screens/edit_product_page.dart';
import 'package:balink_mobile/Product/Widgets/vehicle_carousel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:balink_mobile/Product/Models/product_model.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'product_detail_page.dart';
import 'package:balink_mobile/Product/Widgets/filter.dart';

class ProductPageAdmin extends StatefulWidget {
  const ProductPageAdmin({super.key});

  @override
  State<ProductPageAdmin> createState() => _ProductAdminPageState();
}

class _ProductAdminPageState extends State<ProductPageAdmin> with SingleTickerProviderStateMixin {
  final Color blue400 = const Color.fromRGBO(32, 73, 255, 1); // Bright Blue
  final Color yellow = const Color.fromRGBO(255, 203, 48, 1);  // Bright Yellow
  String _searchQuery = '';
  double _minPrice = 0;
  double _maxPrice = 1000000;
  int _minKm = 0;
  int _maxKm = 1000000;
  int _minYear = 2000;
  int _maxYear = DateTime
      .now()
      .year;

  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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

        final matchesKm = product.fields.kmDriven >= _minKm &&
            product.fields.kmDriven <= _maxKm;

        final matchesYear = product.fields.year >= _minYear &&
            product.fields.year <= _maxYear;

        return matchesQuery && matchesPrice && matchesKm && matchesYear;
      }).toList();
    });
  }

  void _updateFilter(String query, double minPrice, double maxPrice, int minKm,
      int maxKm, int minYear, int maxYear) {
    setState(() {
      _searchQuery = query;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _minKm = minKm;
      _maxKm = maxKm;
      _minYear = minYear;
      _maxYear = maxYear;
      _filterProducts();
    });
  }

  void _resetFilter() {
    setState(() {
      _searchQuery = '';
      _minPrice = 0;
      _maxPrice = 1000000;
      _minKm = 0;
      _maxKm = 1000000;
      _minYear = 2000;
      _maxYear = DateTime
          .now()
          .year;
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

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final request = context.read<CookieRequest>();
        return AlertDialog(
          title: const Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product.fields.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                // Store context before async gap
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                Navigator.of(dialogContext).pop(); // Close the dialog

                // Move async operation outside of onPressed
                _handleDelete(request, product, scaffoldMessenger);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

// Separate method to handle deletion
  Future<void> _handleDelete(
      CookieRequest request,
      Product product,
      ScaffoldMessengerState scaffoldMessenger,
      ) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/product/delete_product_flutter/${product.pk}/',
        {},
      );

      if (response['status'] == 'success') {
        await _refreshProducts(request);

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${product.fields.name} deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Failed to delete product: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addToCart(BuildContext context, String productId) async {
    final request = context.read<CookieRequest>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/cart/add-to-cart-flutter/$productId/',
        {},
      );

      if (response['message'] != null) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    // Get screen width to determine layout
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    // Calculate number of grid columns based on screen width
    int getCrossAxisCount(double width) {
      if (width < 600) return 1; // Mobile phones
      if (width < 900) return 2; // Tablets
      if (width < 1200) return 3; // Small desktops
      return 4; // Large desktops
    }

    // Calculate child aspect ratio based on screen width
    double getChildAspectRatio(double width) {
      if (width < 600) return 1.1; // Taller cards on mobile
      return 0.9; // Wider cards on larger screens
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.black, // Set the color to black
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Our",
              style: TextStyle(
                color: yellow,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              " Products ",
              style: TextStyle(
                color: blue400,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Icon(
              Icons.directions_car_rounded,
              color: blue400,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              ).then((_) => _refreshProducts(request));
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
            // Carousel Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: RentalPromoCarousel(),
              ),
            ),

            // Filter Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 600 ? 8.0 : 16.0,
                  vertical: 8.0,
                ),
                child: FilterWidget(
                  onApply: _updateFilter,
                  onReset: _resetFilter,
                ),
              ),
            ),

            // Products Grid
            FutureBuilder<List<Product>>(
              future: fetchProducts(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                if (_allProducts.isEmpty) {
                  _allProducts = snapshot.data!;
                  _filteredProducts = _allProducts;
                }

                if (_filteredProducts.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 100),
                          Text('No products found'),
                        ],
                      ),
                    ),
                  );
                }

                _animationController.forward(from: 0);

                return SliverPadding(
                  padding: EdgeInsets.all(screenWidth < 600 ? 8.0 : 16.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(screenWidth),
                      childAspectRatio: getChildAspectRatio(screenWidth),
                      crossAxisSpacing: screenWidth < 600 ? 8 : 16,
                      mainAxisSpacing: screenWidth < 600 ? 8 : 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final product = _filteredProducts[index];
                        return FadeTransition(
                          opacity: _animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.9, end: 1.0)
                                .animate(_animation),
                            child: _buildResponsiveProductCard(
                              context,
                              product,
                              screenWidth < 600,
                            ),
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
          ).then((_) => _refreshProducts(request));
        },
        backgroundColor: colorScheme.primary,
        tooltip: 'Add New Product',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildResponsiveProductCard(BuildContext context, Product product,
      bool isMobile) {
    final request = context.watch<CookieRequest>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailPage(
                      product: product,
                      allProducts: _allProducts,
                    ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: LayoutBuilder(
              builder: (context, cardConstraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  // Important to prevent expansion
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
                            return const Center(
                              child: CircularProgressIndicator(),
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

                    // Content Section
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Prevent expansion
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product.fields.name,
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // Price
                            Text(
                              "Rp. ${product.fields.price.toStringAsFixed(
                                  2)}/day",
                              style: TextStyle(
                                fontSize: isMobile ? 11 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Vehicle Details
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildDetailChip(
                                    icon: Icons.calendar_month,
                                    text: product.fields.year.toStringAsFixed(
                                        0),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildDetailChip(
                                    icon: Icons.speed,
                                    text: "${product.fields.kmDriven
                                        .toStringAsFixed(0)} km",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Action Buttons
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Add to Cart Button
                                Expanded(
                                  child: SizedBox(
                                    height: 32, // Fixed height
                                    child: ElevatedButton(
                                      onPressed: () => _addToCart(context,product.pk),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: yellow,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8),
                                        ),
                                      ),
                                      child: Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                            fontSize: isMobile ? 14 : 16),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),

                                // Action Icons
                                IconButton(
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    maxWidth: 32,
                                    minHeight: 32,
                                    maxHeight: 32,
                                  ),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: isMobile ? 18 : 20,
                                  ),
                                  onPressed: () =>
                                      _showDeleteConfirmationDialog(
                                          context, product),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProductPage(product: product),
                                      ),
                                    ).then((_) => _refreshProducts(request));
                                  },
                                  tooltip: 'Edit Product',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.grey.shade600),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}