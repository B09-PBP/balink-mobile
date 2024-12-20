import 'dart:convert';

// Fungsi untuk mengonversi JSON string menjadi List<RideModels>
List<RideModels> rideModelsFromJson(String str) =>
    List<RideModels>.from(json.decode(str).map((x) => RideModels.fromJson(x)));

// Fungsi untuk mengonversi List<RideModels> menjadi JSON string
String rideModelsToJson(List<RideModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// Kelas RideModels untuk menyimpan data rides
class RideModels {
  final String id;
  final String rideName;
  final int price; // Tambahan price agar bisa sesuai dengan cart
  bool isInCart; // Status apakah produk sudah masuk cart

  RideModels({
    required this.id,
    required this.rideName,
    required this.price,
    this.isInCart = false, // Default false jika belum masuk cart
  });

  // Factory untuk membuat objek dari JSON
  factory RideModels.fromJson(Map<String, dynamic> json) => RideModels(
        id: json["id"],
        rideName: json["rideName"],
        price: json["price"], // Harga produk
        isInCart: json["isInCart"] ?? false, // Default false
      );

  // Fungsi untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "rideName": rideName,
        "price": price,
        "isInCart": isInCart,
      };
}