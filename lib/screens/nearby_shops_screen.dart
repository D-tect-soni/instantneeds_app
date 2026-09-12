import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'shop_details_screen.dart';
import 'package:geolocator/geolocator.dart';

class NearbyShopsScreen extends StatefulWidget {
  final String category;

  const NearbyShopsScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<NearbyShopsScreen> createState() => _NearbyShopsScreenState();
}

class _NearbyShopsScreenState extends State<NearbyShopsScreen> {
  bool isLoading = true;

  List<dynamic> shops = [];

  @override
  void initState() {
    super.initState();
    loadShops();
  }

  Future<void> loadShops() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please turn on Location")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await ApiService.getNearbyShops(
        category: widget.category,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        shops = response["shops"] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shops.isEmpty
          ? const Center(
              child: Text("No Shops Found", style: TextStyle(fontSize: 18)),
            )
          : RefreshIndicator(
              onRefresh: loadShops,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];

                  final double rating = ((shop["rating"] ?? 0) as num)
                      .toDouble();

                  final bool verified = shop["isVerified"] == true;

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
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
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop["shopName"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      shop["category"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: verified
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        verified
                                            ? "✔ Verified"
                                            : "⏳ Pending Verification",
                                        style: TextStyle(
                                          color: verified
                                              ? Colors.green
                                              : Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  shop["address"] ?? "Address not available",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          if (shop["phone"] != null &&
                              shop["phone"].toString().isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(shop["phone"]),
                              ],
                            ),

                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 6),
                              Text(
                                rating <= 0
                                    ? "New Shop"
                                    : rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(
                                Icons.near_me,
                                color: Colors.blue,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${shop["distance"] ?? "--"} km away",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(
                                Icons.storefront,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "View Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ShopDetailsScreen(
                                      shop: shop,
                                      serviceName: widget.category,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
