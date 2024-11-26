import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Model model;
  String pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    model: modelValues.map[json["model"]]!,
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": modelValues.reverse[model],
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  String name;
  int year; // Year should be an int
  double price; // Price should be a double
  int kmDriven;
  String imageUrl;
  Dealer dealer;

  Fields({
    required this.name,
    required this.year,
    required this.price,
    required this.kmDriven,
    required this.imageUrl,
    required this.dealer,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    name: json["name"],
    year: json["year"], // The year is already an int, so no need to parse it
    price: double.tryParse(json["price"]) ?? 0.0, // Ensure price is parsed as a double
    kmDriven: json["km_driven"],
    imageUrl: json["image_url"],
    dealer: dealerValues.map[json["dealer"]]!,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "year": year,
    "price": price.toString(), // Convert price back to string when encoding
    "km_driven": kmDriven,
    "image_url": imageUrl,
    "dealer": dealerValues.reverse[dealer],
  };
}

enum Dealer {
  BALI_BIJA_CAR_RENTAL,
  DENPASAR_TRANSPORT,
  GARUDA_BALI_TRANSPORT,
  MJ_TRANS_TOUR_RENTAL,
  SANTIKA_BALI_RENTAL
}

final dealerValues = EnumValues({
  "Bali Bija Car Rental": Dealer.BALI_BIJA_CAR_RENTAL,
  "Denpasar Transport": Dealer.DENPASAR_TRANSPORT,
  "Garuda Bali Transport ": Dealer.GARUDA_BALI_TRANSPORT,
  "MJ TRANS TOUR & RENTAL ": Dealer.MJ_TRANS_TOUR_RENTAL,
  "Santika Bali Rental": Dealer.SANTIKA_BALI_RENTAL
});

enum Model {
  PRODUCT_PRODUCT
}

final modelValues = EnumValues({
  "product.product": Model.PRODUCT_PRODUCT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
