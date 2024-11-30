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

  String _selectedPrivilege = "customer"; // Default privilege value

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue.shade800,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      const Text(
                        'Sign up to get started',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.badge, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        value: _selectedPrivilege,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedPrivilege = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Privilege',
                          prefixIcon: const Icon(Icons.star, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: "customer", child: Text("Customer")),
                          DropdownMenuItem(value: "admin", child: Text("Admin")),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () async {
                          String username = _usernameController.text;
                          String name = _nameController.text;
                          String privilege = _selectedPrivilege;
                          String password = _passwordController.text;
                          String confirmPassword = _confirmPasswordController.text;

                          if (password != confirmPassword) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('Passwords do not match!'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
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


                          if (response['status'] == 'success') {
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: const Text('Registration successful!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                            }
                          } else {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Registration Failed'),
                                  content: Text(response['message']),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[700],
                          foregroundColor: Colors.blue.shade900,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.yellow[700],
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
