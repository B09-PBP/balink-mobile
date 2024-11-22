import 'package:flutter/material.dart';
import 'left_drawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Balink',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.directions_car_rounded,
                        size: 100,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome to Balink!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your trusted vehicle rental app in Bali, Denpasar. '
                            'Explore the beauty of Bali with ease and comfort.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Action: Navigate to the product page or onboarding
                },
                icon: const Icon(Icons.explore),
                label: const Text(
                  'Explore Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Start your journey today!',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              const Text(
                '© 2024 Balink, All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }
}
