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
  // Fetch bookmarks from the server
  Future<List<BookmarkModel>> fetchBookmarks(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/bookmarks/json/');

    var data = response;
    List<BookmarkModel> listBookmark = [];
    for (var d in data) {
      if (d != null) {
        listBookmark.add(BookmarkModel.fromJson(d));
      }
    }
    return listBookmark;
  }

  // Arahkan user ke halaman form untuk buat bookmark baru
  void _navigateToFormPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookmarkFormPage()),
    ).then((_) {
      // Refresh tampilan ketika kembali dari form
      setState(() {});
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
          onUpdate: () {
            // Setelah sukses update, panggil setState agar data ter-refresh
            setState(() {});
          },
        );
      },
    );
  }

  // Hapus bookmark di Django
  Future<void> _deleteBookmark(BookmarkModel bookmark) async {
    // Tanyakan dulu ke user untuk konfirmasi
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

    // Jika user tidak jadi menghapus, hentikan proses
    if (confirmed == null || !confirmed) return;

    // Lanjutkan hapus bookmark
    final request = context.read<CookieRequest>();
    final url = 'http://127.0.0.1:8000/bookmarks/delete-bookmark-flutter/${bookmark.id}/';

    try {
      // Tergantung implementasi di Django:
      // - Kalau view hapus pakai method POST, gunakan request.post(url, {});
      // - Kalau pakai method DELETE, maka gunakan request.delete(url);
      //   (pastikan CookieRequest / library yang Anda pakai mendukung .delete)
      final response = await request.post(url, {});

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark deleted successfully')),
        );
        // Refresh tampilan
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete bookmark: ${response['message'] ?? ''}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting bookmark: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      drawer: const LeftDrawer(),
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
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
        backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
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
    );
  }

  // Build the bookmark list view
  Widget _buildBookmarkList(List<BookmarkModel> bookmarks) {
    return ListView.builder(
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
                // Title + Edit/Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bookmark.product.name, 
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit, 
                            color: Color.fromRGBO(32, 73, 255, 1),
                          ),
                          onPressed: () {
                            _showUpdateModal(bookmark);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteBookmark(bookmark);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Gambar
                Image.network(
                  bookmark.product.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),

                // Priority
                Text('Priority: ${bookmark.priority}'),

                // Note
                Text('Note: ${bookmark.note}'),

                // Reminder
                Text('Reminder: $reminderFormat'),
              ],
            ),
          ),
        );
      },
    );
  }
}