// To parse this JSON data, do
//
//     final bookmarkModel = bookmarkModelFromJson(jsonString);

import 'dart:convert';

List<BookmarkModel> bookmarkModelFromJson(String str) => List<BookmarkModel>.from(json.decode(str).map((x) => BookmarkModel.fromJson(x)));

String bookmarkModelToJson(List<BookmarkModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookmarkModel {
    String model;
    int pk;
    Fields fields;

    BookmarkModel({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String product;
    String note;
    String priority;
    DateTime reminder;

    Fields({
        required this.user,
        required this.product,
        required this.note,
        required this.priority,
        required this.reminder,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        note: json["note"],
        priority: json["priority"],
        reminder: DateTime.parse(json["reminder"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "note": note,
        "priority": priority,
        "reminder": reminder.toIso8601String(),
    };
}