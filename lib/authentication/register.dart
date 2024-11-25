import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:balink_mobile/authentication/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  String _selectedPrivilege = 'customer'; // Default privilege value
  final List<String> _privileges = ['customer', 'admin'];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECE9E6), Color(0xFFB8C6DB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedPrivilege,
                          decoration: InputDecoration(
                            labelText: 'Choose Your Privilege',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          items: _privileges
                              .map((privilege) => DropdownMenuItem<String>(
                            value: privilege,
                            child: Text(
                              privilege[0].toUpperCase() +
                                  privilege.substring(1),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPrivilege = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Username',
                          hintText: 'Enter your username',
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hintText: 'Enter your password',
                          isPassword: true,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Password Confirmation',
                          hintText: 'Confirm your password',
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            String name = _nameController.text;
                            String username = _usernameController.text;
                            String password1 = _passwordController.text;
                            String password2 = _confirmPasswordController.text;
                            String privilege = _selectedPrivilege;

                            if (password1.length < 8 ||
                                !RegExp(r'[A-Z]').hasMatch(password1) ||
                                !RegExp(r'[a-z]').hasMatch(password1) ||
                                !RegExp(r'[0-9]').hasMatch(password1)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password must be at least 8 characters long, and include upper and lower case letters, and numbers.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final response = await request.postJson(
                              "http://127.0.0.1:8000/auth/register-mobile/",
                              jsonEncode({
                                "name": name,
                                "username": username,
                                "password1": password1,
                                "password2": password2,
                                "privilege": privilege,
                              }),
                            );
                            if (context.mounted) {
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Successfully registered!'),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      response['message'] ??
                                          'Failed to register!',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already Have an Account? ",
                      style: TextStyle(color: Colors.blue),
                      children: [
                        TextSpan(
                          text: "Log In Here!",
                          style: TextStyle(
                            color: Colors.orange,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
