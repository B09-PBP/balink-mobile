import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:balink_mobile/bookmarks/models/bookmark_product_models.dart';
import 'bookmark_form.dart';
import 'package:balink_mobile/bookmarks/widgets/update_bookmark_modal.dart';
import 'package:intl/intl.dart';
import 'package:balink_mobile/left_drawer.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  // Fetch user's bookmarks from the server
  Future<List<BookmarkModel>> fetchBookmarks(CookieRequest request) async {
    final response = await request.get('https://nevin-thang-balink.pbp.cs.ui.ac.id/bookmarks/json/');
    List<BookmarkModel> listBookmark = [];
    for (var d in response) {
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
      setState(() {}); // Refresh tampilan ketika kembali dari form
    });
  }

  // Tampilkan modal update di bottom sheet
  void _showUpdateModal(BookmarkModel bookmark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // agar modal full screen saat keyboard muncul
      builder: (BuildContext context) {
        return UpdateBookmarkModal(
          bookmark: bookmark,
          onUpdate: () => setState(() {}), // Refresh data
        );
      },
    );
  }

  // Hapus bookmark di Django
  Future<void> _deleteBookmark(BookmarkModel bookmark) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${bookmark.product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == null || !confirmed) return;

    final request = context.read<CookieRequest>(); // ignore: use_build_context_synchronously
    final url = 'https://nevin-thang-balink.pbp.cs.ui.ac.id/bookmarks/delete-bookmark-flutter/${bookmark.id}/';
    try {
      final response = await request.post(url, {});
      if (response['status'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark deleted successfully')),
        );
        setState(() {});
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete bookmark: ${response['message'] ?? ''}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting bookmark: $e')),
      );
    }
  }

  // Display saat tidak ada bookmarks
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
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
                backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Add New Bookmark',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the bookmark list view (shrinkWrap + no scrolling => let parent scroll)
  Widget _buildBookmarkList(List<BookmarkModel> bookmarks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookmarks.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final reminderFormat = DateFormat('EEEE, d MMM yyyy').format(bookmark.reminder);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: product name + edit/delete icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product name (expanded to handle overflow)
                    Expanded(
                      child: Text(
                        bookmark.product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromRGBO(32, 73, 255, 1)),
                          onPressed: () => _showUpdateModal(bookmark),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteBookmark(bookmark),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    bookmark.product.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey,
                        alignment: Alignment.center,
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Priority, note, reminder
                Text(
                  'Priority: ${bookmark.priority}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Note: ${bookmark.note}',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Reminder: $reminderFormat',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "My ",
              style: TextStyle(
                color: Color.fromRGBO(255, 203, 48, 1),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              "Bookmark",
              style: TextStyle(
                color: Color.fromRGBO(32, 73, 255, 1),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.bookmark_rounded,
              color: Color.fromRGBO(32, 73, 255, 1),
            ),
          ],
        ),
      ),
      // SingleChildScrollView so the entire column can scroll
      body: FutureBuilder<List<BookmarkModel>>(
        future: fetchBookmarks(request),
        builder: (context, snapshot) {
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Keep the gradient header
                  _buildGradientHeader(screenWidth),
                  _buildEmptyState(),
                ],
              ),
            );
          }

          final bookmarks = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                // Keep the gradient header
                _buildGradientHeader(screenWidth),
                // Tampilkan list bookmark
                _buildBookmarkList(bookmarks),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToFormPage,
        backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGradientHeader(double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromRGBO(32, 73, 255, 1),
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      // Bagian konten header
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gambar
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/bookmark.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add your Bookmark!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep track of your favorite items here. Quickly find them whenever you need!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _navigateToFormPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 203, 48, 1),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Bookmark',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}