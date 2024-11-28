import 'package:flutter/material.dart';
import 'package:balink_mobile/Product/Models/product_model.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'product_detail_page.dart';
import 'package:balink_mobile/Product/Widgets/carousel.dart';
import 'package:balink_mobile/Product/Widgets/filter.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Function to fetch the products
  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/product/json/'); // Replace with your API URL
    var data = response;

    List<Product> productList = [];
    for (var d in data) {
      if (d != null) {
        productList.add(Product.fromJson(d)); // Assuming you have a fromJson method in your Product model
      }
    }
    return productList;
  }

  // Filter logic
  String searchQuery = '';
  double minPrice = 0;
  double maxPrice = 1000000;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Products'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Carousel widget for showcasing featured products
              CarouselWidget(),
              const SizedBox(height: 16),
              // Filter widget
              FilterWidget(
                onApply: () {
                  setState(() {
                    searchQuery = ''; // Set actual search query based on input
                  });
                },
                onReset: () {
                  setState(() {
                    // Reset filters
                    searchQuery = '';
                    minPrice = 0;
                    maxPrice = 1000000;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Product list
              FutureBuilder(
                future: fetchProducts(request),
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products available at the moment.',
                        style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                      ),
                    );
                  } else {
                    final filteredProducts = snapshot.data!.where((product) {
                      // Apply filters, for example by name or price range
                      bool matchesQuery = product.fields.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                      bool matchesPrice = product.fields.price >= minPrice &&
                          product.fields.price <= maxPrice;

                      return matchesQuery && matchesPrice;
                    }).toList();

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two items per row for better spacing
                        crossAxisSpacing: 12, // Increased spacing
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (_, index) {
                        final product = filteredProducts[index];
                        return Card(
                          elevation: 4, // Slightly higher elevation for depth
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.fields.imageUrl != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product.fields.imageUrl!,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.fields.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Price: \$${product.fields.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


