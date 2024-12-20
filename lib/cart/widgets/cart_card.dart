import 'package:balink_mobile/cart/models/cart_models.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class CartWidget extends StatelessWidget {
  final CartEntry cart;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CartWidget({
    Key? key,
    required this.cart,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cart.fields.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Tanggal: ${_formatDate(cart.fields.date)}'),
            const SizedBox(height: 4),
            Text('Alamat: ${cart.fields.address}'),
            const SizedBox(height: 8),
            const Text(
              'Mobil yang dipilih:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cart.fields.car.map((car) => Text('• $car')).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}