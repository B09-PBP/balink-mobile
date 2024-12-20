import 'package:balink_mobile/cart/models/cart_models.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartEntry> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems(); // Memanggil fungsi untuk mengambil data keranjang
  }

  // Fungsi untuk mengambil data keranjang dari API
  Future<void> _fetchCartItems() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/cart/get_cart/'));

      if (response.statusCode == 200) {
        setState(() {
          _cartItems = cartEntryFromJson(response.body);
        });
      } else {
        throw Exception('Gagal memuat item keranjang');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: _cartItems.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = _cartItems[index];
                return ListTile(
                  title: Text(cartItem.fields.name),  // Nama produk
                  subtitle: Text('Alamat: ${cartItem.fields.address}'),
                  trailing: Text('${cartItem.fields.car.length} mobil'),
                );
              },
            ),
    );
  }
}