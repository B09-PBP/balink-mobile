// To parse this JSON data, do
//
//     final reviewProductEntry = reviewProductEntryFromJson(jsonString);

import 'dart:convert';

List<ReviewProductEntry> reviewProductEntryFromJson(String str) => List<ReviewProductEntry>.from(json.decode(str).map((x) => ReviewProductEntry.fromJson(x)));

String reviewProductEntryToJson(List<ReviewProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewProductEntry {
    int id;
    String image;
    String rideName;

    ReviewProductEntry({
        required this.id,
        required this.image,
        required this.rideName,
    });

    factory ReviewProductEntry.fromJson(Map<String, dynamic> json) => ReviewProductEntry(
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