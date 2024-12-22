import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Color _primaryBlue = const Color.fromRGBO(32, 73, 255, 1);
  final Color _accentYellow =  const Color.fromRGBO(255, 203, 48, 1);

  String _selectedPrivilege = "customer";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: _primaryBlue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  Text(
                    'Create BaLink Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: _primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Join BaLink and start renting today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  _buildCustomTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16.0),
                  _buildCustomTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.badge,
                  ),
                  const SizedBox(height: 16.0),

                  // Privilege Dropdown with Custom Styling
                  DropdownButtonFormField<String>(
                    value: _selectedPrivilege,
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: 'Account Type',
                      labelStyle: TextStyle(color: _primaryBlue),
                      prefixIcon: Icon(Icons.account_circle, color: _primaryBlue),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryBlue, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryBlue, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedPrivilege = newValue!;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: "customer", child: Text("Customer")),
                      DropdownMenuItem(value: "admin", child: Text("Admin")),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Password Fields
                  _buildCustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 16.0),
                  _buildCustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24.0),

                  // Register Button with Gradient
                  ElevatedButton(
                    onPressed: () => _registerUser(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentYellow,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Login Redirect
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey.shade600),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: _accentYellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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

  // Custom TextField Builder for Consistent Styling
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _primaryBlue),
        prefixIcon: Icon(icon, color: _primaryBlue),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Registration Logic
  void _registerUser(CookieRequest request) async {
    String username = _usernameController.text;
    String name = _nameController.text;
    String privilege = _selectedPrivilege;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Password Matching Validation
    if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match!');
      return;
    }

    final response = await request.post(
      "http://127.0.0.1:8000/auth/register-mobile/",
      jsonEncode({
        'username': username,
        'name': name,
        'privilege': privilege,
        'password1': password,
        'password2': confirmPassword,
      }),
    );

    // Handle Registration Response
    if (response['status']) {
      _handleSuccessfulRegistration();
    } else {
      _showErrorDialog(response['message']);
    }
  }

  // Helper method to show error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Error', style: TextStyle(color: _primaryBlue)),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Helper method to handle successful registration
  void _handleSuccessfulRegistration() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
  }
}