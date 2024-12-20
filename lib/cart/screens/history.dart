import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model untuk Item di History
class HistoryItem {
  final String id;
  final String name;
  final String address;
  final String date;
  final List<Map<String, dynamic>> cars;

  HistoryItem({
    required this.id,
    required this.name,
    required this.address,
    required this.date,
    required this.cars,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      date: json['date'],
      cars: List<Map<String, dynamic>>.from(
          json['car'].map((car) => {'name': car['name'], 'price': car['price']})),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> _historyItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final url =
        Uri.parse("http://127.0.0.1:8000/cart/api/history/");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json', // Header tanpa token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['history'];
        setState(() {
          _historyItems =
              data.map((json) => HistoryItem.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch history");
      }
    } catch (e) {
      print("Error fetching history: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Order History",
          style: TextStyle(
            color: Color.fromRGBO(32, 73, 255, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _historyItems.isEmpty
              ? const Center(
                  child: Text(
                    "No order history available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _historyItems.length,
                  itemBuilder: (context, index) {
                    final history = _historyItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              "Order ID: ${history.id}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("Name: ${history.name}"),
                            Text("Address: ${history.address}"),
                            Text("Date: ${history.date}"),
                            const SizedBox(height: 12),
                            const Text(
                              "Rented Cars:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: history.cars.map((car) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(car['name']),
                                    Text("Rp ${car['price']}"),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}