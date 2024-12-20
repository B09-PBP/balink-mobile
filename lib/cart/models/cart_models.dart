import 'dart:convert';

class CartEntry {
  final String model;
  final int pk;
  final CartFields fields;

  CartEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory CartEntry.fromJson(Map<String, dynamic> json) => CartEntry(
        model: json["model"],
        pk: json["pk"],
        fields: CartFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class CartFields {
  final int user;
  final String name;
  final DateTime date;
  final String address;
  final List<String> car;

  CartFields({
    required this.user,
    required this.name,
    required this.date,
    required this.address,
    required this.car,
  });

  factory CartFields.fromJson(Map<String, dynamic> json) => CartFields(
        user: json["user"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        address: json["address"],
        car: List<String>.from(json["car"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "address": address,
        "car": List<dynamic>.from(car.map((x) => x)),
      };
}

// Fungsi untuk mengonversi JSON menjadi List<CartEntry>
List<CartEntry> cartEntryFromJson(String str) => List<CartEntry>.from(
    json.decode(str).map((x) => CartEntry.fromJson(x)));

// Fungsi untuk mengonversi List<CartEntry> ke dalam format JSON
String cartEntryToJson(List<CartEntry> data) => json.encode(
    List<dynamic>.from(data.map((x) => x.toJson())));