import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final data =
          await ApiService.getOrders();

      setState(() {
        orders = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
        ),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    "No Orders Found",
                  ),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder:
                      (context, index) {

                    final order =
                        orders[index];

                    return Card(
                      margin:
                          const EdgeInsets.all(
                              10),
                      child: ListTile(
                        leading: const Icon(
                          Icons.shopping_bag,
                          color: Colors.teal,
                        ),
                        title: Text(
                          order["serviceName"] ??
                              "",
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              order["address"] ??
                                  "",
                            ),
                            Text(
                              "Qty: ${order["quantity"]}",
                            ),
                          ],
                        ),
                        trailing: Text(
                          "₹${order["amount"]}",
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            color:
                                Colors.green,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}