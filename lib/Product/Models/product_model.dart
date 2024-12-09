import 'dart:convert';

// Conversion functions
List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  final String? model;
  final String pk;
  final Fields fields;

  Product({
    this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    model: json["model"] as String?,
    pk: json["pk"].toString(),
    fields: Fields.fromJson(json["fields"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  final String name;
  final int year;
  final double price;
  final int kmDriven;
  final String imageUrl;
  final String dealer;

  Fields({
    required this.name,
    required this.year,
    required this.price,
    required this.kmDriven,
    required this.imageUrl,
    required this.dealer,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    name: json["name"] ?? '',
    year: _parseYear(json["year"]),
    price: _parsePrice(json["price"]),
    kmDriven: _parseKmDriven(json["km_driven"]),
    imageUrl: json["image_url"] ?? '',
    dealer: json["dealer"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "year": year,
    "price": price.toString(),
    "km_driven": kmDriven,
    "image_url": imageUrl,
    "dealer": dealer,
  };

  // Helper parsing methods with fallback values
  static int _parseYear(dynamic value) {
    if (value is int) return value;
    try {
      return int.parse(value.toString());
    } catch (_) {
      return DateTime.now().year;
    }
  }

  static double _parsePrice(dynamic value) {
    if (value is double) return value;
    try {
      return double.parse(value.toString());
    } catch (_) {
      return 0.0;
    }
  }

  static int _parseKmDriven(dynamic value) {
    if (value is int) return value;
    try {
      return int.parse(value.toString());
    } catch (_) {
      return 0;
    }
  }
}