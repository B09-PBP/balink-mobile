import 'package:flutter/material.dart';
import 'package:balink_mobile/Product/Models/product_model.dart'; // Import your product model
import 'package:balink_mobile/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart'; // Import LeftDrawer

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Function to fetch the products (similar to fetchMood)
  Future<List<Product>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/products/'); // Replace with your API URL

    var data = response;

    List<Product> productList = [];
    for (var d in data) {
      if (d != null) {
        productList.add(Product.fromJson(d)); // Assuming you have a fromJson method in your Product model
      }
    }
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Assuming you're using some kind of request wrapper
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No products available at the moment.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final product = snapshot.data![index].fields; // Assuming your Product model has a fields property
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${product.name}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Price: ${product.price}"),
                      const SizedBox(height: 10),
                      Text("Year: ${product.year} | ${product.kmDriven} km"),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
