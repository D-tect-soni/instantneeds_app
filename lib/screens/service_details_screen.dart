import 'package:flutter/material.dart';
import 'order_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
final String serviceName;

const ServiceDetailsScreen({
super.key,
required this.serviceName,
});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF5F7FA),


  appBar: AppBar(
    title: Text(serviceName),
    backgroundColor: Colors.teal,
  ),

  body: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const SizedBox(height: 20),

        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.home_repair_service,
            color: Colors.white,
            size: 50,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          serviceName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Fast and trusted local service providers near you.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 25),

        const Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(
              Icons.store,
              color: Colors.teal,
            ),
            title: Text("Local Provider"),
            subtitle: Text("Rating: ⭐ 4.8"),
          ),
        ),

        const SizedBox(height: 15),

        const Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(
              Icons.access_time,
              color: Colors.orange,
            ),
            title: Text("Estimated Time"),
            subtitle: Text("30 - 60 Minutes"),
          ),
        ),

        const SizedBox(height: 15),

        const Card(
          elevation: 4,
          child: ListTile(
            leading: Icon(
              Icons.currency_rupee,
              color: Colors.green,
            ),
            title: Text("Starting Price"),
            subtitle: Text("₹99"),
          ),
        ),

        const Spacer(),

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
                    serviceName: serviceName,
                  ),
                ),
              );
            },
            child: const Text(
              "Book Now",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
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
