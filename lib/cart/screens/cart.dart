// ignore_for_file: use_build_context_synchronously

import 'package:balink_mobile/cart/screens/checkout_form.dart';
import 'package:balink_mobile/cart/screens/history.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balink_mobile/cart/models/cart_models.dart';
import 'package:balink_mobile/cart/widgets/cart_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  List<CartEntry> _cartItems = [];
  bool _isLoading = true;
  int totalItems = 0;
  double totalPrice = 0;
  
  final Color blue400 = const Color.fromRGBO(32, 73, 255, 1);
  final Color yellow = const Color.fromRGBO(255, 203, 48, 1);

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    setState(() => _isLoading = true);
    final request = context.read<CookieRequest>();

    try {
      final response = await request.get('http://127.0.0.1:8000/cart/get-user-cart/');
      if (response != null && response is List) {
        List<CartEntry> items = response.map((item) => CartEntry.fromJson(item)).toList();

        double total = 0;
        for (var item in items) {
          total += item.fields.price;
        }

        setState(() {
          _cartItems = items;
          totalItems = items.length;
          totalPrice = total;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFromCart(String productName) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/cart/remove-product-from-cart-flutter/',
        {
          'product_name': productName, // Kirimkan nama produk sebagai parameter
        },
      );

      if (response['message'] != null) {
        // Tampilkan snackbar untuk pesan sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Perbarui state untuk menghapus item dari daftar lokal
        setState(() {
          _cartItems.removeWhere((item) => item.fields.name == productName);
          totalItems = _cartItems.length;
          totalPrice = _cartItems.fold(0, (sum, item) => sum + item.fields.price);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove item: ${response['error'] ?? "Unknown error"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing from cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> confirmBooking(String customerName, String deliveryAddress) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/cart/booking-cart-flutter/',
        {
          'customer_name': customerName,
          'delivery_address': deliveryAddress,
        },
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Bersihkan keranjang di frontend
        setState(() {
          _cartItems.clear();
          totalItems = 0;
          totalPrice = 0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to checkout: ${response['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during checkout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "My ",
              style: TextStyle(
                color: yellow,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Cart ",
              style: TextStyle(
                color: blue400,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Icon(
              Icons.shopping_cart,
              color: blue400,
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Cart Summary Card
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: blue400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Header with cart icon and history button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      'My Cart ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const HistoryPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Order History',
                                      style: TextStyle(
                                        color: blue400,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Ride count
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Ride',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '$totalItems',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white24),
                            // Total price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rp ${totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Book Now button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: yellow,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: totalItems == 0
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CheckoutForm(
                                              cartItems: _cartItems,
                                              totalPrice: totalPrice,
                                              onCheckoutSuccess: () {
                                                setState(() {
                                                  _fetchCartItems();
                                                });
                                              },
                                            );
                                          },
                                        );
                                      },
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Cart Items or Empty State
                Expanded(
                  child: _cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cartItems.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            return CartCard(
                              cartEntry: _cartItems[index],
                              onRemove: () => _removeFromCart(_cartItems[index].fields.name),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
