import 'package:balink_mobile/landing.dart';
import 'package:flutter/material.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:balink_mobile/Product/Screens/product_page_admin.dart';
import 'package:balink_mobile/bookmarks/screens/bookmark_page.dart';

class MainNavigationScaffold extends StatefulWidget {
  const MainNavigationScaffold({super.key});

  @override
  _MainNavigationScaffoldState createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _selectedIndex = 0;

  // Pages to navigate
  final List<Widget> _pages = [
    // Replace these with your actual page widgets
    const MyHomePage(), // Home Page
    const ProductPageAdmin(),                 // Product Page
    const Placeholder(color: Colors.green), // Review Page
    const BookmarkPage(),                     // Bookmark Page
    const Placeholder(color: Colors.orange),// Article Page
    const Placeholder(color: Colors.purple),// Cart Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const LeftDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Product'),
          BottomNavigationBarItem(icon: Icon(Icons.reviews), label: 'Review'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Article'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}