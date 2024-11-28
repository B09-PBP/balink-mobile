import 'dart:async';
import 'package:flutter/material.dart';

class CarouselWidget extends StatefulWidget {
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Widget> _carouselItems = [
    CarouselItem(
      title: 'Exclusive Transportation Collection',
      subtitle: 'Elevate Your Experience',
      description: 'Premium range of transportation options for all occasions.',
    ),
    CarouselItem(
      title: 'Luxury Vehicles',
      subtitle: 'Ride in Style',
      description: 'Choose from a fleet of luxury cars for any event.',
    ),
    CarouselItem(
      title: 'Affordable Options',
      subtitle: 'Budget Friendly',
      description: 'Transportation solutions that fit your budget.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _carouselItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230, // Atur tinggi container
      child: PageView.builder(
        controller: _pageController,
        itemCount: _carouselItems.length,
        itemBuilder: (context, index) {
          return _carouselItems[index];
        },
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;

  const CarouselItem({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade500]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView( // Tambahkan ini untuk menghindari overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue.shade300),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
              onPressed: () {},
              child: const Text('Explore Now', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
