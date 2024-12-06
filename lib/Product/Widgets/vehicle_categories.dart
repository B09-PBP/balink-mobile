import 'package:flutter/material.dart';

class VehicleCategoriesWidget extends StatelessWidget {
  final Function(String) onCategorySelected;

  const VehicleCategoriesWidget({
    Key? key,
    required this.onCategorySelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Sedan', 'icon': Icons.directions_car},
      {'name': 'SUV', 'icon': Icons.car_rental},
      {'name': 'Luxury', 'icon': Icons.directions_car_filled},
      {'name': 'Sports', 'icon': Icons.sports_motorsports},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => onCategorySelected(category['name'] as String),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(
                      category['icon'] as IconData,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}