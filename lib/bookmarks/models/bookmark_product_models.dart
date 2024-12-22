// To parse this JSON data, do
//
//     final bookmarkModel = bookmarkModelFromJson(jsonString);

import 'dart:convert';

List<BookmarkModel> bookmarkModelFromJson(String str) => List<BookmarkModel>.from(json.decode(str).map((x) => BookmarkModel.fromJson(x)));

String bookmarkModelToJson(List<BookmarkModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookmarkModel {
    int id;
    String note;
    String priority;
    DateTime reminder;
    Product product;

    BookmarkModel({
        required this.id,
        required this.note,
        required this.priority,
        required this.reminder,
        required this.product,
    });

    factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        id: json["id"],
        note: json["note"],
        priority: json["priority"],
        reminder: DateTime.parse(json["reminder"]),
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "priority": priority,
        "reminder": "${reminder.year.toString().padLeft(4, '0')}-${reminder.month.toString().padLeft(2, '0')}-${reminder.day.toString().padLeft(2, '0')}",
        "product": product.toJson(),
    };
}

class Product {
    String name;
    String imageUrl;

    Product({
        required this.name,
        required this.imageUrl,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image_url": imageUrl,
    };
}