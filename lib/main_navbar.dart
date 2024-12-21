import 'package:balink_mobile/authentication/login.dart';
import 'package:balink_mobile/landing.dart';
import 'package:balink_mobile/review/screens/review_adminpage.dart';
import 'package:balink_mobile/review/screens/review_customerpage.dart';
import 'package:flutter/material.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:balink_mobile/Product/Screens/product_page_admin.dart';

class MainNavigationScaffold extends StatefulWidget {
  final bool isLoggedIn;
  const MainNavigationScaffold({super.key, required this.isLoggedIn});

  @override
  _MainNavigationScaffoldState createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  int _selectedIndex = 0;

  // Pages to navigate
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize pages, with home page always accessible
    _pages = [
      const MyHomePage(), // Home Page (always accessible)
      widget.isLoggedIn ? const ProductPageAdmin() : const LoginPage(),
      widget.isLoggedIn 
          // ? const ReviewProductPage() 
          ? const ReviewProductAdminPage() // Review Page
          : const LoginPage(),
      widget.isLoggedIn
          ? const Placeholder(color: Colors.red)   // Bookmark Page
          : const LoginPage(),
      widget.isLoggedIn
          ? const Placeholder(color: Colors.orange) // Article Page
          : const LoginPage(),
      widget.isLoggedIn
          ? const Placeholder(color: Colors.purple)  // Cart Page
          : const LoginPage(),
    ];
  }

  void _onItemTapped(int index) {
    // If the selected page requires login and user is not logged in,
    // show login page
    if (!widget.isLoggedIn && index != 0) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginPage())
      );
      return;
    }

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
        unselectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}