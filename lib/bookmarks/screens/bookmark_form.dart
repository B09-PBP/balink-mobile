import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balink_mobile/Product/Models/product_model.dart';
import 'package:intl/intl.dart';
import 'package:balink_mobile/bookmarks/widgets/search_product.dart'; 
import 'package:balink_mobile/bookmarks/widgets/product_grid.dart';

class BookmarkFormPage extends StatefulWidget {
  const BookmarkFormPage({super.key});

  @override
  State<BookmarkFormPage> createState() => _BookmarkFormPageState();
}

class _BookmarkFormPageState extends State<BookmarkFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String? _selectedPriority;
  DateTime? _selectedReminderDate;

  // Product selection variables
  List<Product> _allProducts = [];       // Semua product
  List<Product> _displayedProducts = []; // Product yang ditampilkan (hasil filter)
  bool _isLoadingProducts = true;
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch products from the backend
  Future<void> _fetchProducts() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('http://127.0.0.1:8000/product/json/');

    setState(() {
      _allProducts = response.map<Product>((json) => Product.fromJson(json)).toList();
      _displayedProducts = List.from(_allProducts); // Awalnya sama dengan all
      _isLoadingProducts = false;
    });
  }

  // Search functionality
  void _searchProducts() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _displayedProducts = List.from(_allProducts);
      } else {
        _displayedProducts = _allProducts
            .where((prod) => prod.fields.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // Date picker for reminder
  Future<void> _selectReminderDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedReminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedReminderDate) {
      setState(() {
        _selectedReminderDate = picked;
      });
    }
  }

  // Submit form (line 246)
  Future<void> _submitForm() async {
    // Pastikan field note terisi dan priority terpilih
    if (!_formKey.currentState!.validate()) return;

    // Pastikan product terpilih
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product')),
      );
      return;
    }

    // Pastikan reminder dipilih
    if (_selectedReminderDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reminder date')),
      );
      return;
    }

    final request = context.read<CookieRequest>();
    final response = await request.post(
      'http://127.0.0.1:8000/bookmarks/create-bookmark-flutter/',
      {
        "product_id": _selectedProduct!.pk.toString(),
        "note": _noteController.text,
        "priority": _selectedPriority!,
        "reminder": _selectedReminderDate!.toIso8601String(),
      },
    );

    if (response['status'] == 'success') {
      // Check if the widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark added successfully!')),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(    // ignore: use_build_context_synchronously

        const SnackBar(content: Text('Failed to add bookmark. Please try again.')),
      );
    }
  }

  // Build product grid area
  Widget _buildProductGridSection() {
    return Column(
      children: [
        SearchProductWidget(
          searchController: _searchController,
          onSearch: _searchProducts,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return ProductGridWidget(
              products: _displayedProducts,
              onProductSelect: (product) {
                setState(() {
                  _selectedProduct = product;
                });
              },
              // Send constraints supaya grid bisa menyesuaikan
              maxWidth: constraints.maxWidth,
            );
          },
        ),
      ],
    );
  }

  // Build form after product is selected
  Widget _buildSelectedProductForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _selectedProduct!.fields.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected Product: ${_selectedProduct!.fields.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a note';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'H', child: Text('High')),
                      DropdownMenuItem(value: 'M', child: Text('Medium')),
                      DropdownMenuItem(value: 'L', child: Text('Low')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a priority';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectReminderDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Reminder',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _selectedReminderDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedReminderDate!)
                            : 'Select a date',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Submit Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm, // <-- line 246
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Tombol untuk kembali memilih product
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedProduct = null;
                        });
                      },
                      child: const Text(
                        'Change Product?',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add ",
              style: TextStyle(
                color: Color.fromRGBO(255, 203, 48, 1),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Bookmark",
              style: TextStyle(
                color: Color.fromRGBO(32, 73, 255, 1),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.bookmark_rounded,
              color: Color.fromRGBO(32, 73, 255, 1),
            ),
          ],
        ),
      ),
      body: _isLoadingProducts
          ? const Center(child: CircularProgressIndicator())
          : _selectedProduct == null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildProductGridSection(),
                )
              : _buildSelectedProductForm(),
    );
  }
}