import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'payment_screen.dart';

class OrderScreen extends StatefulWidget {
  final String serviceName;

  const OrderScreen({
    super.key,
    required this.serviceName,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController addressController =
      TextEditingController();

  int quantity = 1;
  final int pricePerUnit = 99;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalAmount = quantity * pricePerUnit;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Book Service"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              widget.serviceName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Service Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Quantity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 35,
                  ),
                ),

                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 35,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(
                  Icons.currency_rupee,
                  color: Colors.green,
                ),
                title: const Text(
                  "Total Amount",
                ),
                trailing: Text(
                  "₹$totalAmount",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.teal,
                ),
                onPressed: () async {
                  if (addressController.text
                      .trim()
                      .isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please enter address",
                        ),
                      ),
                    );
                    return;
                  }

                  try {
                    final response =
                        await ApiService
                            .createOrder(
                      serviceName:
                          widget.serviceName,
                      address:
                          addressController
                              .text
                              .trim(),
                      quantity: quantity,
                      amount: totalAmount,
                    );

                    print(
                      "Order Response => $response",
                    );

                    if (response["order"] !=
                        null) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Order Saved Successfully",
                          ),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentScreen(
                            amount:
                                totalAmount,
                          ),
                        ),
                      );
                    } else {
                      if (!mounted) return;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            response["message"] ??
                                "Order Save Failed",
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    print(
                      "Order Error => $e",
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Proceed To Payment",
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