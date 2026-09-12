import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'customer/review_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data = await ApiService.getOrders();

      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
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
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text("No Orders Found"),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              order["serviceName"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),

                                Text(
                                  order["address"] ?? "",
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Quantity : ${order["quantity"]}",
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Status : ${order["orderStatus"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        order["orderStatus"] ==
                                                "Completed"
                                            ? Colors.green
                                            : order["orderStatus"] ==
                                                    "Accepted"
                                                ? Colors.blue
                                                : order["orderStatus"] ==
                                                        "Cancelled"
                                                    ? Colors.red
                                                    : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              "₹${order["amount"]}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),

                          if (order["orderStatus"] ==
                              "Completed")
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(
                                      12, 0, 12, 12),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.star),
                                  label: const Text(
                                    "Rate Now",
                                  ),
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.amber,
                                    foregroundColor:
                                        Colors.black,
                                  ),
                                  onPressed: () async {
                                    final result =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ReviewScreen(
                                          orderId:
                                              order["_id"],
                                          providerId:
                                              order[
                                                  "providerId"],
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      loadOrders();
                                    }
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}