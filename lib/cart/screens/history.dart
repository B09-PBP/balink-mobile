import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<dynamic>> fetchHistory(CookieRequest request) async {
    final response = await request.get('https://nevin-thang-balink.pbp.cs.ui.ac.id/cart/get-history/');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    const Color blue400 = Color.fromRGBO(32, 73, 255, 1); // Bright Blue
    const Color yellow = Color.fromRGBO(255, 203, 48, 1); // Bright Yellow

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Container(
              color: Colors.white, // Background putih
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  // Back Button di Kiri
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color.fromRGBO(32, 73, 255, 1)), // Ikon panah biru
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),

                  // Spacer untuk memusatkan Judul dan Ikon
                  const Spacer(),

                  // Judul dan Ikon di Tengah
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "My" dengan warna kuning
                      Text(
                        'My',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: yellow, // Warna kuning
                        ),
                      ),
                      SizedBox(width: 4), // Spasi kecil antara kata
                      // "History" dengan warna biru
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: blue400, // Warna biru
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.shopping_cart_sharp,
                        color: Color.fromRGBO(32, 73, 255, 1), // Warna biru
                        size: 24,
                      ),
                    ],
                  ),

                  // Spacer untuk menjaga kesimetrisan layout
                  const Spacer(),
                ],
              ),
            ),

            // Body Content
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchHistory(context.watch<CookieRequest>()),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No orders found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return HistoryCard(
                        username: item['username'],
                        name: item['name'],
                        address: item['address'],
                        dateOrdered: item['date'],
                        productName: item['product_name'],
                        imageUrl: item['image_url'],
                        price: item['price'].toDouble(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}