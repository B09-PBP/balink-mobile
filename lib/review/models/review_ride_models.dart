// To parse this JSON data, do
//
//     final ReviewRideModels = ReviewRideModelsFromJson(jsonString);

import 'dart:convert';

List<ReviewRideModels> reviewRideModelsFromJson(String str) => List<ReviewRideModels>.from(json.decode(str).map((x) => ReviewRideModels.fromJson(x)));

String reviewRideModelsToJson(List<ReviewRideModels> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewRideModels {
    String id;
    String image;
    String rideName;

    ReviewRideModels({
        required this.id,
        required this.image,
        required this.rideName,
    });

    factory ReviewRideModels.fromJson(Map<String, dynamic> json) => ReviewRideModels(
        id: json["id"],
        image: json["image"],
        rideName: json["rideName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "rideName": rideName,
    };
}