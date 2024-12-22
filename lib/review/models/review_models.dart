// // To parse this JSON data, do
// //
// //     final ReviewModels = ReviewModelsFromJson(jsonString);

import 'dart:convert';

List<ReviewModels> reviewModelsFromJson(String str) => List<ReviewModels>.from(json.decode(str).map((x) => ReviewModels.fromJson(x)));

String reviewModelsToJson(List<ReviewModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewModels {
    String id;
    String image;
    String username;
    String rideName;
    int rating;
    String reviewMessage;

    ReviewModels({
        required this.id,
        required this.image,
        required this.username,
        required this.rideName,
        required this.rating,
        required this.reviewMessage,
    });

    factory ReviewModels.fromJson(Map<String, dynamic> json) => ReviewModels(
        id: json["id"],
        image: json["image"],
        username: json["username"],
        rideName: json["rideName"],
        rating: json["rating"],
        reviewMessage: json["reviewMessage"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "username": username,
        "rideName": rideName,
        "rating": rating,
        "reviewMessage": reviewMessage,
    };
}