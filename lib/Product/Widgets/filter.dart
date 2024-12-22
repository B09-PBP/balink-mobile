import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterWidget extends StatefulWidget {
  final Function(String, double, double, int, int, int, int) onApply;
  final VoidCallback onReset;

  const FilterWidget({
    super.key,
    required this.onApply,
    required this.onReset
  });

  @override
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minKmController = TextEditingController();
  final TextEditingController _maxKmController = TextEditingController();
  final TextEditingController _minYearController = TextEditingController();
  final TextEditingController _maxYearController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _applyFilter() {
    final String searchQuery = _searchController.text.trim();
    final double minPrice = double.tryParse(_minPriceController.text) ?? 0;
    final double maxPrice = double.tryParse(_maxPriceController.text) ?? 1000000;
    final int minKm = int.tryParse(_minKmController.text) ?? 0;
    final int maxKm = int.tryParse(_maxKmController.text) ?? 1000000;
    final int minYear = int.tryParse(_minYearController.text) ?? 2000;
    final int maxYear = int.tryParse(_maxYearController.text) ?? DateTime.now().year;

    widget.onApply(searchQuery, minPrice, maxPrice, minKm, maxKm, minYear, maxYear);
  }

  void _resetFilter() {
    _searchController.clear();
    _minPriceController.text = '0';
    _maxPriceController.text = '1000000';
    _minKmController.text = '0';
    _maxKmController.text = '1000000';
    _minYearController.text = '2000';
    _maxYearController.text = DateTime.now().year.toString();
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search TextField
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vehicles...',
                prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Price Range Row
            Row(
              children: [
                // Min Price Field
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Min Price',
                      prefixText: 'Rp. ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Max Price Field
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Max Price',
                      prefixText: 'Rp. ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Kilometers Range Row
            Row(
              children: [
                // Min Kilometers Field
                Expanded(
                  child: TextField(
                    controller: _minKmController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Min Kilometers',
                      suffixText: 'km',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Max Kilometers Field
                Expanded(
                  child: TextField(
                    controller: _maxKmController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Max Kilometers',
                      suffixText: 'km',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Year Range Row
            Row(
              children: [
                // Min Year Field
                Expanded(
                  child: TextField(
                    controller: _minYearController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Min Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Max Year Field
                Expanded(
                  child: TextField(
                    controller: _maxYearController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'Max Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                // Reset Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilter,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Apply Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade700,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minKmController.dispose();
    _maxKmController.dispose();
    _minYearController.dispose();
    _maxYearController.dispose();
    super.dispose();
  }
}