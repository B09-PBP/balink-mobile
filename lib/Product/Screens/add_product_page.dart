import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _kmDrivenController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _dealerController = TextEditingController();

  bool _isLoading = false;

  // Improved form validation with specific validation logic
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    // Specific validations based on field type
    switch (fieldName) {
      case 'Year':
        final yearInt = int.tryParse(value);
        if (yearInt == null || yearInt < 1900 || yearInt > DateTime.now().year) {
          return 'Enter a valid year';
        }
        break;
      case 'Price':
        final priceDouble = double.tryParse(value);
        if (priceDouble == null || priceDouble <= 0) {
          return 'Enter a valid price';
        }
        break;
      case 'Kilometers Driven':
        final kmDouble = double.tryParse(value);
        if (kmDouble == null || kmDouble < 0) {
          return 'Enter valid kilometers';
        }
        break;
    }
    return null;
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Fixed URL (removed duplicate http)
        var url = Uri.parse('http://127.0.0.1:8000/product/add_product_flutter/');
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'name': _nameController.text,
            'year': _yearController.text,
            'price': _priceController.text,
            'km_driven': _kmDrivenController.text,
            'image_url': _imageUrlController.text,
            'dealer': _dealerController.text,
          }),
        );

        if (!mounted) return;

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add product'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Handle network errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[100]!,
              Colors.blue[200]!
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  icon: Icons.car_rental,
                  validator: (value) => _validateField(value, 'Product Name'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _yearController,
                  label: 'Year',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateField(value, 'Year'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: 'Price',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateField(value, 'Price'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _kmDrivenController,
                  label: 'Kilometers Driven',
                  icon: Icons.speed,
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateField(value, 'Kilometers Driven'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _imageUrlController,
                  label: 'Image URL',
                  icon: Icons.image,
                  validator: (value) => _validateField(value, 'Image URL'),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _dealerController,
                  label: 'Dealer',
                  icon: Icons.store,
                  validator: (value) => _validateField(value, 'Dealer'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                      'Add Product',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextField builder for consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Cleanup controllers to prevent memory leaks
  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _kmDrivenController.dispose();
    _imageUrlController.dispose();
    _dealerController.dispose();
    super.dispose();
  }
}