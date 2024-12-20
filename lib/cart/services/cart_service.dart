// lib/services/api_service.dart

import 'dart:convert';
import 'package:balink_mobile/cart/models/cart_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://your-backend-api-url'; // Ganti dengan URL backend Django Anda

  static Future<void> addToCart(int userId, int productId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add-to-cart/$userId/$productId/'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to add product to cart');
    }
  }

  static Future<List<CartEntry>> getCart(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/cart/view-cart/$userId/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => CartEntry.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cart');
    }
  }
}