import 'dart:convert';
import 'package:balink_mobile/Product/Models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _baseUrl = 'http://127.0.0.1:8000';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  late final TextEditingController _priceController;
  late final TextEditingController _kmDrivenController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _dealerController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.product.fields.name);
    _yearController = TextEditingController(text: widget.product.fields.year.toString());
    _priceController = TextEditingController(text: widget.product.fields.price.toString());
    _kmDrivenController = TextEditingController(text: widget.product.fields.kmDriven.toString());
    _imageUrlController = TextEditingController(text: widget.product.fields.imageUrl);
    _dealerController = TextEditingController(text: widget.product.fields.dealer);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _kmDrivenController.dispose();
    _imageUrlController.dispose();
    _dealerController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/product/edit_product_flutter/${widget.product.pk}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'year': int.parse(_yearController.text),
          'price': double.parse(_priceController.text),
          'km_driven': int.parse(_kmDrivenController.text),
          'image_url': _imageUrlController.text,
          'dealer': _dealerController.text,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Product updated successfully', isSuccess: true);
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Failed to update product';
        _showSnackBar(error);
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      String errorMessage, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
        IconData? prefixIcon,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Theme.of(context).primaryColor) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
        keyboardType: keyboardType,
        validator: validator ?? (value) => value == null || value.isEmpty ? errorMessage : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Product'),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            _nameController,
                            'Product Name',
                            'Please enter product name',
                            prefixIcon: Icons.shopping_bag,
                          ),
                          _buildTextField(
                            _yearController,
                            'Year',
                            'Please enter a valid year',
                            keyboardType: TextInputType.number,
                            validator: (value) => int.tryParse(value ?? '') == null ? 'Enter a valid number' : null,
                            prefixIcon: Icons.calendar_today,
                          ),
                          _buildTextField(
                            _priceController,
                            'Price',
                            'Please enter a valid price',
                            keyboardType: TextInputType.number,
                            validator: (value) => double.tryParse(value ?? '') == null ? 'Enter a valid number' : null,
                            prefixIcon: Icons.attach_money,
                          ),
                          _buildTextField(
                            _kmDrivenController,
                            'Kilometers Driven',
                            'Please enter a valid number',
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.speed,
                          ),
                          _buildTextField(
                            _imageUrlController,
                            'Image URL',
                            'Please enter a valid URL',
                            prefixIcon: Icons.image,
                          ),
                          _buildTextField(
                            _dealerController,
                            'Dealer',
                            'Please enter dealer name',
                            prefixIcon: Icons.person,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProduct,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                          : const Text(
                        'Update Product',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}