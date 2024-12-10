import 'package:flutter/material.dart';
import 'package:balink_mobile/bookmarks/widgets/bookmark_card.dart';
import 'package:balink_mobile/bookmarks/models/bookmark_product_models.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  Future<List<BookmarkModel>> fetchBookmarks(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/bookmarks/');
    return bookmarkModelFromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookmarks'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<BookmarkModel>>(
        future: fetchBookmarks(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load bookmarks'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No bookmarks available'),
            );
          }

          final bookmarks = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              final fields = bookmark.fields; // Extract fields for easy access

              return BookmarkCard(
                imageUrl: fields.product, // Assuming this is the product image URL
                name: 'Product #${bookmark.pk}', // Custom name for the product
                priority: fields.priority,
                note: fields.note,
                reminder: fields.reminder.toIso8601String(),
                onUpdate: () {
                  // Implement update logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Update feature for bookmark #${bookmark.pk}')),
                  );
                },
                onDelete: () {
                  // Implement delete logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted bookmark #${bookmark.pk}')),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-bookmark/'); // Navigate to the form page
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
