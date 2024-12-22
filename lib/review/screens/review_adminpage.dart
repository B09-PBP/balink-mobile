import 'package:balink_mobile/left_drawer.dart';
import 'package:balink_mobile/review/models/review_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';


class ReviewProductAdminPage extends StatefulWidget {
  const ReviewProductAdminPage({super.key});

  @override
  State<ReviewProductAdminPage> createState() => _ReviewProductAdminPageState();
}

class _ReviewProductAdminPageState extends State<ReviewProductAdminPage> {
  Future<List<ReviewModels>> fetchReviews(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/review/all-reviews-flutter/');
    // final response = await request.get('http://nevin-thang-balink.pbp.cs.ui.ac.id/review/all-reviews-flutter/');

    List<ReviewModels> listReview = [];
    for (var d in response) {
      if (d != null) {
        listReview.add(ReviewModels.fromJson(d));
      }
    }
    return listReview;
  }

  Future<void> deleteReview(CookieRequest request, String reviewId) async {
    final response = await request.post(
      'http://127.0.0.1:8000/review/delete-review-flutter/$reviewId/',
      // 'hhttp://nevin-thang-balink.pbp.cs.ui.ac.id/review/delete-review-flutter/$reviewId/',
      {},
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      setState(() {}); // Refresh data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
    }
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
              "Our ",
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
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<ReviewModels>>(
        future: fetchReviews(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching reviews'),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews available',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final review = snapshot.data![index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      review.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    review.rideName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("⭐ ${review.rating}"),
                      Text(
                        review.reviewMessage.length > 50
                            ? "${review.reviewMessage.substring(0, 50)}..."
                            : review.reviewMessage,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromRGBO(32, 73, 255, 1)),
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Review"),
                          content: const Text("Are you sure you want to delete this review?"),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await deleteReview(request, review.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}