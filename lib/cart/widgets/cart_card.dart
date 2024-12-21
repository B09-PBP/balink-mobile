import 'package:flutter/material.dart';
import 'package:balink_mobile/cart/models/cart_models.dart';

class CartCard extends StatefulWidget {
  final CartEntry cartEntry;
  final VoidCallback onRemove;

  const CartCard({
    Key? key,
    required this.cartEntry,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> with SingleTickerProviderStateMixin {
  final Color blue400 = const Color.fromRGBO(32, 73, 255, 1);
  final Color yellow = const Color.fromRGBO(255, 203, 48, 1);

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Fade Animation
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start animation when widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRemove() {
    // Reverse the animation before removing the item
    _controller.reverse().then((_) {
      widget.onRemove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Menentukan lebar container berdasarkan ukuran layar
    final double containerWidth = screenWidth > 600
        ? screenWidth * 0.6 // Untuk layar lebar, gunakan 60% dari lebar layar
        : screenWidth * 0.9; // Untuk layar kecil, gunakan 90% dari lebar layar
    final double containerHeight = containerWidth / 2; // Tinggi proporsional

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizeTransition(
        sizeFactor: _fadeAnimation,
        child: Align(
          alignment: Alignment.center, // Memastikan card di tengah layar
          child: Container(
            width: containerWidth,
            margin: const EdgeInsets.symmetric(vertical: 8), // Jarak antar card
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2), // Shadow di bawah
                ),
              ],
            ),
            child: Stack(
              children: [
                // Gambar Produk
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: widget.cartEntry.fields.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.cartEntry.fields.imageUrl,
                          width: containerWidth,
                          height: containerHeight,
                          fit: BoxFit.cover, // Menyesuaikan gambar
                        )
                      : Container(
                          width: containerWidth,
                          height: containerHeight,
                          color: Colors.grey[200],
                          child: const Icon(Icons.car_rental),
                        ),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Detail Produk
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cartEntry.fields.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp${widget.cartEntry.fields.price.toStringAsFixed(2)}/day',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _handleRemove,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}