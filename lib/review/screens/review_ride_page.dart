import 'package:balink_mobile/review/screens/review_form.dart';
import 'package:balink_mobile/review/widgets/search_ride_review.dart';
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

  List<ReviewRideModels> allRides = [];
  List<ReviewRideModels> displayedRides = [];
  final TextEditingController searchController = TextEditingController();

  void _searchRides() {
    String query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        displayedRides = allRides;
      } else {
        displayedRides = allRides
            .where((ride) => ride.rideName.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const Color blue400 = Color.fromRGBO(32, 73, 255, 1);
    const Color yellow = Color.fromRGBO(255, 203, 48, 1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add ",
              style: TextStyle(
                color: yellow,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Review",
              style: TextStyle(
                color: blue400,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<ReviewRideModels>>(
          future: fetchRides(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No rides available.'));
            }

            allRides = snapshot.data!;
            if (displayedRides.isEmpty) {
              displayedRides = allRides;
            }

            return Column(
              children: [
                SearchRideReview(
                  searchController: searchController,
                  onSearch: _searchRides,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600
                          ? 3
                          : 2;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: displayedRides.length,
                        itemBuilder: (context, index) {
                          final product = displayedRides[index];
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
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 120,
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.error, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      product.rideName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
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
              ],
            );
          },
        ),
      ),
    );
  }
}