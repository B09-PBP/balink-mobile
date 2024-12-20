import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // Create separate form keys for each step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _kmDrivenController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _dealerController = TextEditingController();

  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Basic Information',
    'Specifications',
    'Additional Details',
  ];

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

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

  bool _validateCurrentStep() {
    return _formKeys[_currentStep].currentState?.validate() ?? false;
  }

  Future<void> _submitProduct() async {
    // Validate all forms before submission
    bool allFormsValid = _formKeys.every((key) => key.currentState?.validate() ?? false);

    if (allFormsValid) {
      setState(() {
        _isLoading = true;
      });

      try {
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
          _showSuccessDialog();
        } else {
          _showErrorSnackBar('Failed to add product');
        }
      } catch (e) {
        _showErrorSnackBar('Network error: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 64)
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text(
              'Product Added Successfully!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      _buildStep(
        0,
        'Enter product details',
        [
          _buildAnimatedField(
            controller: _nameController,
            label: 'Product Name',
            icon: Icons.directions_car,
            validator: (value) => _validateField(value, 'Product Name'),
            delay: 0,
          ),
          _buildAnimatedField(
            controller: _yearController,
            label: 'Year',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
            validator: (value) => _validateField(value, 'Year'),
            delay: 100,
          ),
        ],
      ),
      _buildStep(
        1,
        'Enter vehicle specifications',
        [
          _buildAnimatedField(
            controller: _priceController,
            label: 'Price',
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
            validator: (value) => _validateField(value, 'Price'),
            delay: 0,
          ),
          _buildAnimatedField(
            controller: _kmDrivenController,
            label: 'Kilometers Driven',
            icon: Icons.speed,
            keyboardType: TextInputType.number,
            validator: (value) => _validateField(value, 'Kilometers Driven'),
            delay: 100,
          ),
        ],
      ),
      _buildStep(
        2,
        'Enter additional information',
        [
          _buildAnimatedField(
            controller: _imageUrlController,
            label: 'Image URL',
            icon: Icons.image,
            validator: (value) => _validateField(value, 'Image URL'),
            delay: 0,
          ),
          _buildAnimatedField(
            controller: _dealerController,
            label: 'Dealer',
            icon: Icons.store,
            validator: (value) => _validateField(value, 'Dealer'),
            delay: 100,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add New Product',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_validateCurrentStep()) {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _submitProduct();
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: _buildSteps(),
      ),
    );
  }

  Step _buildStep(int index, String subtitle, List<Widget> fields) {
    return Step(
      title: Text(_stepTitles[index]),
      subtitle: Text(subtitle),
      content: Form(
        key: _formKeys[index],  // Use the corresponding form key for each step
        child: Column(
          children: fields,
        ),
      ),
      isActive: _currentStep >= index,
    );
  }

  Widget _buildAnimatedField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required int delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        keyboardType: keyboardType,
        validator: validator,
      ).animate()
          .fadeIn(delay: Duration(milliseconds: delay))
          .slideX(
        begin: 0.2,
        delay: Duration(milliseconds: delay),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      ),
    );
  }

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