import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ride_models.dart';

class CartService {
  final String baseUrl;

  CartService({required this.baseUrl});

  // Fetch Cart Items
  Future<List<RideModels>> fetchCartItems(String token) async {
    final url = Uri.parse("$baseUrl/api/cart/");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['cart'] as List;
      return data.map((item) => RideModels.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load cart items");
    }
  }

  // Remove Item from Cart
  Future<void> removeItemFromCart(String token, String productId) async {
    final url = Uri.parse("$baseUrl/api/cart/remove/$productId/");
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to remove item");
    }
  }
}