import 'package:flutter/material.dart';

class CarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Updated text style for headlines with new text theme
          Text(
            'Exclusive Transportation Collection',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Elevate Your Experience',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue.shade300),
          ),
          const SizedBox(height: 16),
          Text(
            'Premium range of transportation options for all occasions.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 16),
          // Updated ElevatedButton style to use ElevatedButton.styleFrom with the new API
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade500, // Use backgroundColor instead of primary
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
            onPressed: () {},
            child: Text('Explore Now', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
