import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'package:balink_mobile/bookmarks/models/bookmark_product_models.dart';
import 'bookmark_form.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  // Fetch bookmarks from the server
  Future<List<BookmarkModel>> fetchBookmarks(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/bookmarks/json/');

    // Melakukan decode response menjadi bentuk json
    var data = response;

    // Melakukan konversi data json menjadi object BookmarkModel
    List<BookmarkModel> listBookmark = [];
    for (var d in data) {
      if (d != null) {
        listBookmark.add(BookmarkModel.fromJson(d));
      }
    }
    return listBookmark;
  }

  void _navigateToFormPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookmarkFormPage()),
    ).then((_) {
      // Refresh the page when returning from the form
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:const Color.fromRGBO(32, 73, 255, 1),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BookmarkModel>>(
        future: fetchBookmarks(request),
        builder: (context, AsyncSnapshot<List<BookmarkModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final bookmarks = snapshot.data!;
          return _buildBookmarkList(bookmarks);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFormPage,
        backgroundColor:const Color.fromRGBO(32, 73, 255, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Display when no bookmarks are available
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No bookmarks available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _navigateToFormPage,
            style: ElevatedButton.styleFrom(
              backgroundColor:const Color.fromRGBO(32, 73, 255, 1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Add New Bookmark',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Build the bookmark list view
  Widget _buildBookmarkList(List<BookmarkModel> bookmarks) {
    return ListView.builder(
      itemCount: bookmarks.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final fields = bookmark.fields;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fields.product, // Replace with actual product name
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Priority: ${fields.priority}'),
                Text('Note: ${fields.note}'),
                Text('Reminder: ${fields.reminder}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color.fromRGBO(32, 73, 255, 1),),
                      onPressed: () {
                        // Implement edit functionality here
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Implement delete functionality here
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}