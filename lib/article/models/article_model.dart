// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

List<Article> articleFromJson(String str) =>
    List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
  String model;
  int pk;
  Fields fields;

  Article({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
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
  dynamic ride;
  String title;
  String content;
  String image;
  List<dynamic> comments;
  String image1;
  String image2;
  String image3;

  Fields({
    required this.user,
    required this.ride,
    required this.title,
    required this.content,
    required this.image,
    required this.comments,
    required this.image1,
    required this.image2,
    required this.image3,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        ride: json["ride"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        comments: List<dynamic>.from(json["comments"].map((x) => x)),
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "ride": ride,
        "title": title,
        "content": content,
        "image": image,
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "image1": image1,
        "image2": image2,
        "image3": image3,
      };
}
