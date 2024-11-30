import 'package:balink_mobile/review/screens/review_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balink_mobile/left_drawer.dart';
import 'package:balink_mobile/review/models/review_ride_models.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewRidePage extends StatefulWidget {
  const ReviewRidePage({super.key});

  @override
  State<ReviewRidePage> createState() => _ReviewRidePageState();
}

class _ReviewRidePageState extends State<ReviewRidePage> {
  Future<List<ReviewRideModels>> fetchRides(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/review/all-rides-flutter/');
    // final response = await request.get('http://nevin-thang-balink.pbp.cs.ui.ac.id/review/all-rides-flutter/');    

    var data = response;

    List<ReviewRideModels> listRide = [];
    for (var d in data) {
      if (d != null) {
        listRide.add(ReviewRideModels.fromJson(d));
      }
    }
    return listRide;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<ReviewRideModels>>(
          future: fetchRides(request),
          builder: (context, snapshot) {
            List<ReviewRideModels> products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(child: Text('No rides available.'));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewFormPage(
                          id: product.id,
                          rideName: product.rideName,
                          image: product.image,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            product.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.rideName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}