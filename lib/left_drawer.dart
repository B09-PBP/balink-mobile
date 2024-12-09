import 'package:balink_mobile/review/screens/review_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

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
                request.loggedIn ? 'user@example.com' : 'Not Logged In',
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
                onTap: () => _showSnackBar(context, 'Login'),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.person_add,
                title: 'Register',
                onTap: () => _showSnackBar(context, 'Register'),
              ),
            ],

            if (request.loggedIn)
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () => _showSnackBar(context, 'Logout'),
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
}