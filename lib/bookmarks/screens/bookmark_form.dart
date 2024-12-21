import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'bookmark_page.dart';
import 'package:balink_mobile/Product/Models/product_model.dart';

class BookmarkFormPage extends StatefulWidget {
  const BookmarkFormPage({super.key});

  @override
  State<BookmarkFormPage> createState() => _BookmarkFormPageState();
}

class _BookmarkFormPageState extends State<BookmarkFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedPriority;
  DateTime? _selectedReminderDate;

  // Product selection variables
  List<Product> _products = [];
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
      _products = response.map<Product>((json) => Product.fromJson(json)).toList();
      _isLoadingProducts = false;
    });
  }

  // Show date picker for reminder
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

  // Submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a product')),
        );
        return;
      }

      if (_selectedReminderDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a reminder date')),
        );
        return;
      }

      final request = context.read<CookieRequest>();
      final response = await request.post(
        'http://127.0.0.1:8000/bookmarks/create-bookmark/',
        {
          "product_id": _selectedProduct!.pk.toString(),
          "note": _noteController.text,
          "priority": _selectedPriority!,
          "reminder": _selectedReminderDate!.toIso8601String(),
        },
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark added successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookmarkPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add bookmark. Please try again.')),
        );
      }
    }
  }

  // Build product list
  Widget _buildProductList() {
    if (_isLoadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          child: ListTile(
            leading: Image.network(product.fields.imageUrl),
            title: Text(product.fields.name),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedProduct = product;
                });
              },
              child: const Text('Select'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bookmark'),
        backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product List Section
            _selectedProduct == null
                ? _buildProductList()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Display selected product image
                        Image.network(
                          _selectedProduct!.fields.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        // Display selected product name
                        Text(
                          'Selected Product: ${_selectedProduct!.fields.name}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        // Bookmark Form
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Note Field
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
                              // Priority Dropdown
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
                              // Reminder Date Picker
                              InkWell(
                                onTap: () => _selectReminderDate(context),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Reminder',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: Text(
                                    _selectedReminderDate != null
                                        ? _selectedReminderDate!.toLocal().toString().split(' ')[0]
                                        : 'Select a date',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Submit Button
                              Center(
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
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
}