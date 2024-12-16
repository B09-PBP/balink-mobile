import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balink_mobile/Product/Models/product_model.dart';

class BookmarkFormPage extends StatefulWidget {
  const BookmarkFormPage({super.key});

  @override
  State<BookmarkFormPage> createState() => _BookmarkFormPageState();
}

class _BookmarkFormPageState extends State<BookmarkFormPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  String _priority = '';
  Product? _selectedProduct;

  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/product/json/');
    return productFromJson(response);
  }

  Future<void> _submitBookmark(CookieRequest request) async {
    if (_selectedProduct == null || _priority.isEmpty || _noteController.text.isEmpty || _reminderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final response = await request.post(
      'http://127.0.0.1:8000/bookmarks/',
      {
        'product_id': _selectedProduct!.pk,
        'note': _noteController.text,
        'priority': _priority,
        'reminder': _reminderController.text,
      },
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add bookmark')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Bookmark',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:const Color.fromRGBO(32, 73, 255, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            // Product Grid
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: fetchProducts(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load products'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }

                  final products = snapshot.data!
                      .where((product) => product.fields.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedProduct = product;
                          });
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  product.fields.imageUrl,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              // Product Name and Price
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.fields.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp. ${product.fields.price.toStringAsFixed(2)}",
                                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
                },
              ),
            ),
            const SizedBox(height: 16),
            // Form Fields
            if (_selectedProduct != null) ...[
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                onChanged: (value) => setState(() => _priority = value ?? ''),
                items: const [
                  DropdownMenuItem(value: 'H', child: Text('High')),
                  DropdownMenuItem(value: 'M', child: Text('Medium')),
                  DropdownMenuItem(value: 'L', child: Text('Low')),
                ],
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reminderController,
                decoration: const InputDecoration(
                  labelText: 'Reminder Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitBookmark(request),
                child: const Text('Add Bookmark'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
