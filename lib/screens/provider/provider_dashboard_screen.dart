import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';
import 'provider_profile_screen.dart';
import 'order_details_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  bool isLoading = true;

  // Dashboard Counts
  int totalOrders = 0;
  int pendingOrders = 0;
  int acceptedOrders = 0;
  int completedOrders = 0;

  // Earnings
  int todayEarnings = 0;
  int weekEarnings = 0;
  int monthEarnings = 0;
  int totalEarnings = 0;

  // Orders
  List<dynamic> orders = [];

  // Provider Details
  String providerName = "";
  String providerEmail = "";

  // Shop Details
  String shopName = "";
  String shopCategory = "";
  String shopCity = "";
  String shopLogo = "";

  bool isVerified = false;
  double rating = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      setState(() {
        isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();

      providerName = prefs.getString("name") ?? "";
      providerEmail = prefs.getString("email") ?? "";

      final shop = await ApiService.getMyShop();

      shopName = shop["shopName"] ?? "";
      shopCategory = shop["category"] ?? "";
      shopCity = shop["city"] ?? "";
      shopLogo = shop["shopLogo"] ?? "";
      isVerified = shop["isVerified"] ?? false;
      rating = (shop["rating"] ?? 0).toDouble();

      final dashboard = await ApiService.getProviderDashboard();
      final earnings = await ApiService.getProviderEarnings();

      if (!mounted) return;

      setState(() {
        totalOrders = dashboard["totalOrders"] ?? 0;
        pendingOrders = dashboard["pendingOrders"] ?? 0;
        acceptedOrders = dashboard["acceptedOrders"] ?? 0;
        completedOrders = dashboard["completedOrders"] ?? 0;

        todayEarnings = earnings["today"] ?? 0;
        weekEarnings = earnings["week"] ?? 0;
        monthEarnings = earnings["month"] ?? 0;
        totalEarnings = earnings["total"] ?? 0;

        orders = dashboard["orders"] ?? [];

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
      @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Provider Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // SHOP CARD

                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          CircleAvatar(
                            radius: 45,
                            backgroundImage: shopLogo.isNotEmpty
                                ? NetworkImage(shopLogo)
                                : null,
                            child: shopLogo.isEmpty
                                ? const Icon(Icons.store, size: 45)
                                : null,
                          ),

                          const SizedBox(height: 15),

                          Text(
                            shopName.isEmpty
                                ? providerName
                                : shopName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            shopCategory,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [

                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),

                              Text(shopCity),

                              const SizedBox(width: 20),

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),

                              Text(rating.toString()),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Chip(
                            backgroundColor: isVerified
                                ? Colors.green
                                : Colors.orange,
                            label: Text(
                              isVerified
                                  ? "Verified"
                                  : "Pending",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: dashboardCard(
                          "Today",
                          "₹$todayEarnings",
                          Icons.currency_rupee,
                          Colors.green,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: dashboardCard(
                          "Week",
                          "₹$weekEarnings",
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Expanded(
                        child: dashboardCard(
                          "Month",
                          "₹$monthEarnings",
                          Icons.date_range,
                          Colors.orange,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: dashboardCard(
                          "Total",
                          "₹$totalEarnings",
                          Icons.account_balance_wallet,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: dashboardCard(
                          "Orders",
                          totalOrders.toString(),
                          Icons.shopping_bag,
                          Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: dashboardCard(
                          "Pending",
                          pendingOrders.toString(),
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Expanded(
                        child: dashboardCard(
                          "Accepted",
                          acceptedOrders.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: dashboardCard(
                          "Completed",
                          completedOrders.toString(),
                          Icons.done_all,
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ProviderProfileScreen(),
                          ),
                        );

                        loadDashboard();
                      },
                      icon: const Icon(Icons.person),
                      label: const Text("My Profile"),
                    ),
                  ),

                  const SizedBox(height: 25),
                    const Text(
                    "Recent Orders",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (orders.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text(
                          "No Orders Found",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        return GestureDetector(
                         onTap: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OrderDetailsScreen(order: order),
    ),
  );

  if (result == "accept") {
    await ApiService.acceptOrder(order["_id"]);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order Accepted Successfully"),
      ),
    );

    loadDashboard();
  }

  if (result == "reject") {
    await ApiService.rejectOrder(order["_id"]);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order Rejected Successfully"),
      ),
    );

    loadDashboard();
  }

  if (result == "complete") {
    await ApiService.completeOrder(order["_id"]);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Order Completed Successfully"),
      ),
    );

    loadDashboard();
  }
},
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    order["customerName"] ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                      "Service: ${order["serviceName"] ?? ""}"),

                                  Text(
                                      "Status: ${order["orderStatus"] ?? ""}"),

                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget dashboardCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }
}