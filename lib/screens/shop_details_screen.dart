import 'package:flutter/material.dart';
import 'order_screen.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Map shop;
  final String serviceName;

  const ShopDetailsScreen({
    super.key,
    required this.shop,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shop["shopName"]),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.teal,
              backgroundImage:
                  shop["shopLogo"] != null &&
                          shop["shopLogo"].toString().isNotEmpty
                      ? NetworkImage(shop["shopLogo"])
                      : null,
              child:
                  shop["shopLogo"] == null ||
                          shop["shopLogo"].toString().isEmpty
                      ? const Icon(
                          Icons.store,
                          size: 55,
                          color: Colors.white,
                        )
                      : null,
            ),

            const SizedBox(height: 20),

            Text(
              shop["shopName"],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              shop["category"],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text("${shop["rating"]}"),
              ],
            ),

            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(shop["address"] ?? ""),
            ),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(shop["phone"] ?? ""),
            ),

            ListTile(
              leading: const Icon(Icons.work_history),
              title: Text(
                  "${shop["experience"] ?? 0} Years Experience"),
            ),

            ListTile(
              leading: const Icon(Icons.description),
              title: Text(shop["description"] ?? ""),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderScreen(
                        shopId: shop["_id"],
                        shopName: shop["shopName"],
                        providerId: shop["ownerId"],
                        serviceName: serviceName,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}