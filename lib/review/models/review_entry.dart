// // To parse this JSON data, do
// //
// //     final reviewProductEntry = reviewProductEntryFromJson(jsonString);

import 'dart:convert';

List<ReviewProductEntry> reviewProductEntryFromJson(String str) => List<ReviewProductEntry>.from(json.decode(str).map((x) => ReviewProductEntry.fromJson(x)));

String reviewProductEntryToJson(List<ReviewProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewProductEntry {
    String image;
    String username;
    String rideName;
    int rating;
    String reviewMessage;

    ReviewProductEntry({
        required this.image,
        required this.username,
        required this.rideName,
        required this.rating,
        required this.reviewMessage,
    });

    factory ReviewProductEntry.fromJson(Map<String, dynamic> json) => ReviewProductEntry(
        image: json["image"],
        username: json["username"],
        rideName: json["rideName"],
        rating: json["rating"],
        reviewMessage: json["reviewMessage"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "username": username,
        "rideName": rideName,
        "rating": rating,
        "reviewMessage": reviewMessage,
    };
}