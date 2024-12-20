import 'dart:convert';
import 'package:balink_mobile/cart/screens/cart.dart';
import 'package:balink_mobile/cart/screens/history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CheckoutForm extends StatefulWidget {
  final int total;

  const CheckoutForm({super.key, required this.total});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  String _buyerName = "";
  String _deliveryAddress = "";

  final Color blue400 = const Color.fromRGBO(32, 73, 255, 1); // Bright Blue
  final Color yellow = const Color.fromRGBO(255, 203, 48, 1); // Bright Yellow

  Future<void> _addToHistory(String buyerName, String deliveryAddress) async {
    final request = context.watch<CookieRequest>();

    // Data yang akan dikirim ke API
    final historyData = jsonEncode({
      "buyer_name": buyerName,
      "delivery_address": deliveryAddress,
      "total_price": widget.total,
      "rented_items": [
        {"product_id": 1, "quantity": 2}, // Contoh data produk
        {"product_id": 2, "quantity": 1},
      ],
    });

    final response = await request.postJson(
      "http://127.0.0.1:8000/cart/api/history/", // Ganti dengan endpoint API Anda
      historyData,
    );

    if (response['status'] != 'success') {
      throw Exception("Failed to add to history");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: IconThemeData(color: blue400),
        title: Text(
          "Checkout",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: blue400,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Membuat lebar container lebih kecil
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Booking ",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: yellow,
                      ),
                      children: [
                        TextSpan(
                          text: "Details",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: blue400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buyer Name
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Customer Name",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _buyerName = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Delivery Address
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delivery Address",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your address",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _deliveryAddress = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Address cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Total Price
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Total Price",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp${widget.total},00",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: blue400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              // Ambil instance CookieRequest tanpa mendengarkan perubahan
                              final request = Provider.of<CookieRequest>(context, listen: false);

                              // Kirim data pesanan ke server atau API
                              final response = await request.postJson(
                                "http://nevin-thang-balink.pbp.cs.ui.ac.id/cart/history/", // Ganti dengan endpoint backend Anda
                                jsonEncode({
                                  "buyer_name": _buyerName,
                                  "delivery_address": _deliveryAddress,
                                  "total_price": widget.total,
                                }),
                              );

                              // Periksa apakah response dari server berhasil
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Checkout successful!")),
                                );

                                // Navigasi ke halaman history (pastikan halaman HistoryPage tersedia)
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HistoryPage()), // Sesuaikan dengan navigasi ke HistoryPage Anda
                                );
                              } else {
                                throw Exception("Failed to save order to history");
                              }
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to complete checkout: $error")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue400,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: yellow, // Warna teks kuning
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}