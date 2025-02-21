import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map item;
  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item["title"] ?? "Item Details", 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  item["image"] ?? "https://via.placeholder.com/150",
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Product Title
            Text(item["title"] ?? "No title available",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 8),

            // Product Description
            Text(item["description"] ?? "No description available",
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
            
            const SizedBox(height: 8),

            // Price
            Text(
              item["price"] != null 
                ? "\$${(item["price"] as num).toStringAsFixed(2)}"
                : "Price not available",
              style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Category (Instead of 'Details')
            Text("Category: ${item["category"] ?? "No category"}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // "Add to Cart" Button
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text("Add to Cart", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
