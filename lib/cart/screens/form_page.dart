import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final double totalPrice;

  OrderDetailsPage({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Text('Ba', style: TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Link', style: TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Order Details
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Order Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // Input Customer Name
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Customer Name",
                      border: OutlineInputBorder(),
                      hintText: "Enter your name",
                    ),
                  ),
                  SizedBox(height: 16),
                  // Input Delivery Address
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Delivery Address",
                      border: OutlineInputBorder(),
                      hintText: "Enter your address",
                    ),
                  ),
                  SizedBox(height: 16),
                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rp${totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            // Confirm Button
            ElevatedButton(
              onPressed: () {
                // Aksi konfirmasi
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Order Confirmed"),
                    content: Text("Thank you for your order!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}