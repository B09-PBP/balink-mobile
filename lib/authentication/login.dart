import 'package:balink_mobile/main_navbar.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balink_mobile/authentication/register.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginPage({
    super.key,
    this.onLoginSuccess
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define BaLink's color palette
  final Color _primaryBlue = const Color.fromRGBO(32, 73, 255, 1);
  final Color _accentYellow =  const Color.fromRGBO(255, 203, 48, 1);
  final Color _backgroundBlue = const Color.fromRGBO(32, 73, 255, 1);

  // Password visibility toggle
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: _backgroundBlue,
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
              child: Form( // Wrap with Form for validation
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      'Welcome to BaLink',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: _primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Log in to continue your rental journey',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Username Input with Validation
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: _primaryBlue),
                        prefixIcon: Icon(Icons.person, color: _primaryBlue),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _primaryBlue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Password Input with Visibility Toggle
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: _primaryBlue),
                        prefixIcon: Icon(Icons.lock, color: _primaryBlue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _primaryBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: _primaryBlue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    // Forgot Password (Optional)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Implement forgot password functionality
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: _primaryBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Login Button with Loading State
                    ElevatedButton(
                      onPressed: _isLoading ? null : () => _performLogin(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentYellow,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Register Redirect
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()
                          ),
                        );
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(color: Colors.grey.shade600),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                color: _primaryBlue,
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
      ),
    );
  }

  void _performLogin(CookieRequest request) async {
    // Validate form before attempting login
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Capture BuildContext-dependent values early
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      final response = await request.login(
        "http://127.0.0.1:8000/auth/login-mobile/",
        {
          'username': username,
          'password': password,
        },
      );

      // Check if widget is still mounted before updating state
      if (!mounted) return;

      // Reset loading state
      setState(() {
        _isLoading = false;
      });

      if (request.loggedIn) {
        String message = response['message'];
        String uname = response['username'];

        // Call optional login success callback
        widget.onLoginSuccess?.call();

        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScaffold(
              isLoggedIn: true,
              startingPage: 0,
            ),
          ),
        );

        scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("$message Welcome, $uname."),
              backgroundColor: Colors.green,
            ),
          );
      } else {
        _showLoginErrorDialog(response['message']);
      }
    } catch (e) {
      // Check if widget is still mounted before updating state
      if (!mounted) return;

      // Reset loading state
      setState(() {
        _isLoading = false;
      });

      // Generic error handling
      _showLoginErrorDialog('An unexpected error occurred. Please try again.');
    }
  }

  // Error Dialog for Login Failures
  void _showLoginErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed', style: TextStyle(color: _primaryBlue)),
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
}