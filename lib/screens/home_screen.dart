import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';
import 'provider/provider_dashboard_screen.dart';
import 'nearby_shops_screen.dart';
import 'provider/become_provider_screen.dart';
import 'provider/waiting_approval_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  String userRole = "customer";
  String greeting = "Hello";
  

  final List<Map<String, dynamic>> services = [
    {
      "name": "Laundry",
      "icon": Icons.local_laundry_service,
    },
    {
      "name": "Water",
      "icon": Icons.water_drop,
    },
    {
      "name": "Printing",
      "icon": Icons.print,
    },
    {
      "name": "Food",
      "icon": Icons.fastfood,
    },
    {
      "name": "Plumber",
      "icon": Icons.plumbing,
    },
    {
      "name": "Electrician",
      "icon": Icons.electrical_services,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final response = await ApiService.getProfile();

      final hour = DateTime.now().hour;

      String currentGreeting;

      if (hour < 12) {
        currentGreeting = "Good Morning";
      } else if (hour < 17) {
        currentGreeting = "Good Afternoon";
      } else {
        currentGreeting = "Good Evening";
      }

      setState(() {
        userName = response["name"] ?? "User";
        userRole = response["role"] ?? "user";
        greeting = currentGreeting;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          "InstantNeeds",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Notifications coming soon"),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "$greeting, $userName 👋",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 18,
                  ),

                  SizedBox(width: 5),

                  Text(
                    "Bhopal, Madhya Pradesh",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search services...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.tune),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "🎉 Welcome to InstantNeeds",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Book trusted local services in just a few taps.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Explore Services",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Popular Services",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),
              GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: services.length,
  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    childAspectRatio: 0.90,
  ),
  itemBuilder: (context, index) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NearbyShopsScreen(
              category: services[index]["name"],
            ),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal.shade50,
                child: Icon(
                  services[index]["icon"],
                  size: 32,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                services[index]["name"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                "Starting ₹99",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const Spacer(),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Book Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
),

const SizedBox(height: 30),

const Text(
  "Why Choose InstantNeeds?",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: const Column(
    children: [
      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.verified,
            color: Colors.white,
          ),
        ),
        title: Text("Verified Service Providers"),
        subtitle: Text("Trusted & verified local professionals"),
      ),

      Divider(),

      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.flash_on,
            color: Colors.white,
          ),
        ),
        title: Text("Fast Booking"),
        subtitle: Text("Book services within seconds"),
      ),

      Divider(),

      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.payments,
            color: Colors.white,
          ),
        ),
        title: Text("Secure Payments"),
        subtitle: Text("Safe online payment experience"),
      ),

      Divider(),

      ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.support_agent,
            color: Colors.white,
          ),
        ),
        title: Text("24×7 Customer Support"),
        subtitle: Text("We're always here to help"),
      ),
    ],
  ),
),

const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,

      onTap: (index) async {
          switch (index) {
            case 0:
              break;

            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderHistoryScreen(),
                ),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
              break;

            case 3:
  try {
    final status = await ApiService.getProviderStatus();

    if (!context.mounted) return;

    if (status["registered"] == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const BecomeProviderScreen(),
        ),
      );
    } else if (status["verified"] == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const WaitingApprovalScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProviderDashboardScreen(),
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
  break;
          }
        },

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business_center),
            label: userRole == "provider"
                ? "Dashboard"
                : "Business",
          ),
        ],
      ),
    );
  }
}