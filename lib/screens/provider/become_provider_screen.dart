import 'package:flutter/material.dart';

import 'provider_register_screen.dart';
import 'provider_dashboard_screen.dart';

class BecomeProviderScreen extends StatelessWidget {
  const BecomeProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          "Become a Partner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
            
                child: const Column(
                  children: [

                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.storefront,
                        color: Colors.teal,
                        size: 45,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Grow Your Business",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Join InstantNeeds and connect with thousands of nearby customers looking for trusted services.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
                            const Text(
                "Why Join InstantNeeds?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.currency_rupee,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Earn More Money",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Receive more orders from customers in your nearby area.",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.schedule,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Flexible Working Hours",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Work whenever you want with complete flexibility.",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.people_alt,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Reach More Customers",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Expand your business by connecting with local customers.",
                  ),
                ),
              ),

              const SizedBox(height: 30),
                            const Text(
                "Why Providers Love Us",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.green,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "1000+",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Monthly Bookings",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18),
                        child: Column(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "4.9★",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Customer Rating",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.orange,
                      size: 35,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Start today and receive your first customer after profile approval.",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),
                            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(
                    Icons.app_registration,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Register as Provider",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProviderRegisterScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.teal,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(
                    Icons.dashboard,
                    color: Colors.teal,
                  ),
                  label: const Text(
                    "Open Dashboard",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProviderDashboardScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "InstantNeeds Partner Program © 2026",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}