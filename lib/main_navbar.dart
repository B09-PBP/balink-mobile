import 'package:flutter/material.dart';
import 'package:balink_mobile/authentication/login.dart';
import 'package:balink_mobile/landing.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:balink_mobile/Product/Screens/product_page_admin.dart';

class MainNavigationScaffold extends StatefulWidget {
  final bool isLoggedIn;
  final int startingPage; // Parameter untuk menentukan halaman awal

  const MainNavigationScaffold({
    super.key,
    required this.isLoggedIn,
    required this.startingPage,
  });

  @override
  State<MainNavigationScaffold> createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold> {
  late int _selectedIndex; // Ubah ke `late` agar bisa diinisialisasi di `initState`

  final List<NavigationItem> _navigationItems = [
    const NavigationItem(
      icon: Icons.home,
      label: 'Home',
      requiresAuth: false,
      page: MyHomePage(),
    ),
    const NavigationItem(
      icon: Icons.directions_car,
      label: 'Product',
      requiresAuth: true,
      page: ProductPageAdmin(),
    ),
    const NavigationItem(
      icon: Icons.reviews,
      label: 'Review',
      requiresAuth: true,
      page: Placeholder(color: Colors.green),
    ),
    const NavigationItem(
      icon: Icons.bookmark,
      label: 'Bookmark',
      requiresAuth: true,
      page: Placeholder(color: Colors.orange),
    ),
    const NavigationItem(
      icon: Icons.article,
      label: 'Article',
      requiresAuth: true,
      page: Placeholder(color: Colors.orange),
    ),
    const NavigationItem(
      icon: Icons.shopping_cart,
      label: 'Cart',
      requiresAuth: true,
      page: Placeholder(color: Colors.purple),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Gunakan parameter startingPage untuk inisialisasi _selectedIndex
    _selectedIndex = widget.startingPage;
  }

  Widget _getCurrentPage() {
    final item = _navigationItems[_selectedIndex];
    if (item.requiresAuth && !widget.isLoggedIn) {
      return const LoginPage();
    }
    return item.page;
  }

  void _onItemTapped(int index) {
    final item = _navigationItems[index];
    if (item.requiresAuth && !widget.isLoggedIn) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginPage()),
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
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationItems
            .map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        ))
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: const Color.fromRGBO(32, 73, 255, 1),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Helper class to manage navigation items
class NavigationItem {
  final IconData icon;
  final String label;
  final bool requiresAuth;
  final Widget page;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.requiresAuth,
    required this.page,
  });
}
