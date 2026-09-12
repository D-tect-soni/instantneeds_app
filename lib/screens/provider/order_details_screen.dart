import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order["orderStatus"] ?? "Pending";

    Color statusColor;

    switch (status) {
      case "Accepted":
        statusColor = Colors.green;
        break;
      case "Completed":
        statusColor = Colors.blue;
        break;
      case "Rejected":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                children: [
                  const Icon(Icons.assignment, color: Colors.white, size: 60),

                  const SizedBox(height: 15),

                  Text(
                    "Order #${order["_id"] ?? "N/A"}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= CUSTOMER INFORMATION =================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "Customer Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 25),

                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(order["customerName"] ?? "Unknown Customer"),
                      subtitle: const Text("Customer Name"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: Text(order["phone"] ?? "Not Available"),
                      subtitle: const Text("Phone Number"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.orange),
                      title: Text(order["email"] ?? "Not Available"),
                      subtitle: const Text("Email"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ================= SERVICE INFORMATION =================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.home_repair_service, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "Service Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 25),

                    ListTile(
                      leading: const Icon(Icons.miscellaneous_services),
                      title: Text(order["serviceName"] ?? "N/A"),
                      subtitle: const Text("Service"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.currency_rupee),
                      title: Text("₹${order["amount"] ?? 0}"),
                      subtitle: const Text("Amount"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text("${order["quantity"] ?? 1}"),
                      subtitle: const Text("Quantity"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.payment),
                      title: Text(order["paymentStatus"] ?? "Pending"),
                      subtitle: const Text("Payment Status"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= ADDRESS =================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          "Delivery Address",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 25),

                    Text(
                      order["address"] ?? "Address not available",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ================= CUSTOMER NOTE =================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.sticky_note_2, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          "Customer Note",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 25),

                    Text(
                      order["note"] ?? "No special instructions provided.",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ================= ORDER SUMMARY =================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 25),

                    ListTile(
                      leading: const Icon(Icons.confirmation_number),
                      title: Text(order["_id"] ?? "N/A"),
                      subtitle: const Text("Order ID"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(order["createdAt"] ?? "N/A"),
                      subtitle: const Text("Order Date"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(status),
                      subtitle: const Text("Current Status"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= QUICK ACTIONS =================
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Call feature coming soon"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.call),
                    label: const Text("Call"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("WhatsApp feature coming soon"),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text("WhatsApp"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Open Maps feature coming soon"),
                    ),
                  );
                },
                icon: const Icon(Icons.location_on),
                label: const Text("Open in Maps"),
              ),
            ),

            const SizedBox(height: 25),

            // ================= ORDER ACTION =================
            if (status == "Pending")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, "reject");
                      },
                      child: const Text("Reject"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, "accept");
                      },
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),

            if (status == "Accepted")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "complete");
                  },
                  icon: const Icon(Icons.done_all),
                  label: const Text("Complete Order"),
                ),
              ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
