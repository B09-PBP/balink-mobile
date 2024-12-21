import 'package:flutter/material.dart';

class SearchRideReview extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  const SearchRideReview({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search your ride to review...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: const Text(
            "Search",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}