import 'package:balink_mobile/main_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balink_mobile/authentication/login.dart'; // Create this screen
import 'package:balink_mobile/authentication/register.dart';// Create this screen

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              accountName: Text(
                request.loggedIn ? 'Logged In User' : 'Guest',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                request.loggedIn ? 'Logged in' : 'Not Logged In',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: colorScheme.primary,
                  size: 40,
                ),
              ),
            ),

            // Profile Section
            _buildDrawerItem(
              context,
              icon: Icons.person,
              title: 'Profile',
              onTap: () => _showSnackBar(context, 'Profile'),
            ),

            // Login/Logout/Register Sections Based on Authentication
            if (!request.loggedIn) ...[
              _buildDrawerItem(
                context,
                icon: Icons.login,
                title: 'Login',
                onTap: () => _navigateToLogin(context),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.person_add,
                title: 'Register',
                onTap: () => _navigateToRegister(context),
              ),
            ],

            if (request.loggedIn)
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _performLogout(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(
        title,
        style: TextStyle(color: Colors.blue[700]),
      ),
      onTap: onTap,
    );
  }

  void _showSnackBar(BuildContext context, String route) {
    Navigator.pop(context); // Close the drawer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigating to $route...')),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _navigateToRegister(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _performLogout(BuildContext context) async {
    final request = context.read<CookieRequest>();

    try {
      // Assuming your Django logout endpoint is at '/logout-mobile/'
      final response = await request.logout('http://127.0.0.1:8000/auth/logout-mobile/');

      if (response['status'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Logout successful'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen or home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainNavigationScaffold(isLoggedIn: false)),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Logout failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}