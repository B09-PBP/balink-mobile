import 'package:flutter/material.dart';
import 'package:balink_mobile/Product/Screens/product_page.dart';
import 'package:balink_mobile/article/screen/article_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blue[800],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[700],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Explore Balink',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Landing Page',
              onTap: () => Navigator.pop(context), // Close the drawer
            ),
            _buildDrawerItem(
              context,
              icon: Icons.directions_car,
              title: 'Product Page',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductPage()),
              ),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.bookmark,
              title: 'Bookmark',
              onTap: () => _showSnackBar(context, 'Bookmark'),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.shopping_cart,
              title: 'Cart',
              onTap: () => _showSnackBar(context, 'Cart'),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.article,
              title: 'Article',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ArticlePage()), // Navigasi ke ArticlePage
              ),
            ),
            const Divider(color: Colors.white54, thickness: 1),
            _buildDrawerItem(
              context,
              icon: Icons.login,
              title: 'Login',
              onTap: () => _showSnackBar(context, 'Login'),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => _showSnackBar(context, 'Logout'),
            ),
            _buildDrawerItem(
              context,
              icon: Icons.person_add,
              title: 'Register',
              onTap: () => _showSnackBar(context, 'Register'),
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
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
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
