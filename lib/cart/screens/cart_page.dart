import 'package:balink_mobile/cart/screens/form_page.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Hitung total harga
  double get totalPrice {
    return widget.cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    // Warna biru yang lebih menyala
    final Color blue400 = Color.fromRGBO(32, 73, 255, 1); // Bright Blue
    final Color yellow = Color.fromRGBO(255, 203, 48, 1);  // Bright Yellow

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Text('Ba', style: TextStyle(color: yellow, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Link', style: TextStyle(color: blue400, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Aksi untuk menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Box
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: blue400,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "My Cart",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigasi ke halaman History
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: BorderSide(color: Colors.white, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Order History"),
                    ),
                  ],
                ),
                Divider(color: Colors.white, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ride:", style: TextStyle(color: Colors.white)),
                        Text("${widget.cartItems.length}", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Total:", style: TextStyle(color: Colors.white)),
                        Text("Rp ${totalPrice.toStringAsFixed(2)}", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: widget.cartItems.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(totalPrice: totalPrice),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: yellow,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List Produk
          Expanded(
            child: widget.cartItems.isEmpty
                ? Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(item['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Rp ${item['price'].toStringAsFixed(2)}/day"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                widget.cartItems.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
      ),
      body: Center(
        child: Text("This is the Order History Page."),
      ),
    );
  }
}