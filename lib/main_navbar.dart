import 'package:balink_mobile/article/screen/article_page.dart';
import 'package:balink_mobile/review/screens/review_adminpage.dart';
import 'package:balink_mobile/review/screens/review_customerpage.dart';
import 'package:flutter/material.dart';
import 'package:balink_mobile/cart/screens/cart.dart';
import 'package:balink_mobile/authentication/login.dart';
import 'package:balink_mobile/landing.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:balink_mobile/Product/Screens/product_page_admin.dart';

class MainNavigationScaffold extends StatefulWidget {
  final bool isLoggedIn;
  final int startingPage;

  const MainNavigationScaffold({
    super.key,
    required this.isLoggedIn,
    required this.startingPage,
  });

  @override
  State createState() => _MainNavigationScaffoldState();
}

class _MainNavigationScaffoldState extends State<MainNavigationScaffold>
    with TickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;

  final List<NavigationItem> _navigationItems = [
    const NavigationItem(
      icon: Icons.home_rounded,
      label: 'Home',
      requiresAuth: false,
      page: MyHomePage(),
    ),
    const NavigationItem(
      icon: Icons.directions_car_rounded,
      label: 'Product',
      requiresAuth: true,
      page: ProductPageAdmin(),
    ),
    const NavigationItem(
      icon: Icons.star_rounded,
      label: 'Review',
      requiresAuth: true,
      page: 
      ReviewProductPage(),
      // ReviewProductAdminPage(),
    ),
    const NavigationItem(
      icon: Icons.bookmark_rounded,
      label: 'Bookmark',
      requiresAuth: true,
      page: Placeholder(color: Colors.orange),
    ),
    NavigationItem(
      icon: Icons.article_rounded,
      label: 'Article',
      requiresAuth: true,
      page: ArticlePage(),
    ),
    const NavigationItem(
      icon: Icons.shopping_cart_rounded,
      label: 'Cart',
      requiresAuth: true,
      page: CartPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startingPage;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildPage(Widget page) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: page,
    );
  }

  Widget _getCurrentPage() {
    final item = _navigationItems[_selectedIndex];
    if (item.requiresAuth && !widget.isLoggedIn) {
      return _buildPage(const LoginPage());
    }
    return _buildPage(item.page);
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
    _animationController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const LeftDrawer(),
      body: _getCurrentPage(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            items: _navigationItems.map((item) {
              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(
                    _selectedIndex == _navigationItems.indexOf(item) ? 8.0 : 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedIndex == _navigationItems.indexOf(item)
                        ? colorScheme.primary.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: _selectedIndex == _navigationItems.indexOf(item) ? 28 : 24,
                  ),
                ),
                label: item.label,
              );
            }).toList(),
            currentIndex: _selectedIndex,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

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