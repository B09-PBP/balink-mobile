import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balink_mobile/review/screens/review_customerpage.dart';

class EditReviewPage extends StatefulWidget {
  final String id;
  final String rideName;
  final String image;
  final int currentRating;
  final String currentReviewMessage;

  const EditReviewPage({
    super.key,
    required this.id,
    required this.rideName,
    required this.image,
    required this.currentRating,
    required this.currentReviewMessage,
  });

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends State<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _reviewMessage = "";

  @override
  void initState() {
    super.initState();
    _rating = widget.currentRating;
    _reviewMessage = widget.currentReviewMessage;
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
              "Edit ",
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
            Icon(
              Icons.star_rounded,
              color: yellow,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Review ",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Color.fromRGBO(255, 203, 48, 1),
                      size: 20.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.image,
                    height: 150,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.rideName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _rating.toString(),
                  decoration: InputDecoration(
                    hintText: "Rating (1-5)",
                    labelText: "Rating",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _rating = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Rating must be filled!";
                    }
                    final rating = int.tryParse(value);
                    if (rating == null || rating < 1 || rating > 5) {
                      return "Rating must be between 1 and 5";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _reviewMessage,
                  decoration: InputDecoration(
                    hintText: "Write your review message",
                    labelText: "Review Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 4,
                  onChanged: (String? value) {
                    setState(() {
                      _reviewMessage = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Review message must be filled!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/review/edit-review-flutter/",
                          jsonEncode(<String, String>{
                            'id': widget.id,
                            'rating': _rating.toString(),
                            'review_message': _reviewMessage,
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Review updated successfully!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ReviewProductPage()),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}