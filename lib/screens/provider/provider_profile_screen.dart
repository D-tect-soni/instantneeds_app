import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'edit_profile_screen.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() =>
      _ProviderProfileScreenState();
}

class _ProviderProfileScreenState
    extends State<ProviderProfileScreen> {

  bool isLoading = true;

  Map<String, dynamic> shop = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.getMyShop();

      if (!mounted) return;

      setState(() {
        shop = response;
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

  Widget profileTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.teal,
        ),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? "-" : value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
                      : RefreshIndicator(
              onRefresh: loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [

                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                (shop["shopLogo"] ?? "").toString().isNotEmpty
                                    ? NetworkImage(shop["shopLogo"])
                                    : null,
                            child: (shop["shopLogo"] ?? "")
                                    .toString()
                                    .isEmpty
                                ? const Icon(
                                    Icons.store,
                                    size: 50,
                                    color: Colors.teal,
                                  )
                                : null,
                          ),

                          const SizedBox(height: 15),

                          Text(
                            shop["shopName"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            shop["category"] ?? "",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                (shop["rating"] ?? 0).toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width: 20),

                              Icon(
                                shop["isVerified"] == true
                                    ? Icons.verified
                                    : Icons.pending,
                                color: shop["isVerified"] == true
                                    ? Colors.lightGreenAccent
                                    : Colors.orangeAccent,
                              ),

                              const SizedBox(width: 5),

                              Text(
                                shop["isVerified"] == true
                                    ? "Verified"
                                    : "Pending",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    profileTile(
                      Icons.phone,
                      "Phone",
                      shop["phone"] ?? "",
                    ),

                    profileTile(
                      Icons.location_on,
                      "Address",
                      shop["address"] ?? "",
                    ),

                    profileTile(
                      Icons.location_city,
                      "City",
                      shop["city"] ?? "",
                    ),

                    profileTile(
                      Icons.map,
                      "State",
                      shop["state"] ?? "",
                    ),

                    profileTile(
                      Icons.pin_drop,
                      "Pincode",
                      shop["pincode"]?.toString() ?? "",
                    ),

                    profileTile(
                      Icons.work,
                      "Experience",
                      "${shop["experience"] ?? ""} Years",
                    ),

                    profileTile(
                      Icons.access_time,
                      "Opening Time",
                      shop["openingTime"] ?? "",
                    ),

                    profileTile(
                      Icons.lock_clock,
                      "Closing Time",
                      shop["closingTime"] ?? "",
                    ),

                    profileTile(
                      Icons.description,
                      "Description",
                      shop["description"] ?? "",
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const EditProfileScreen(),
                            ),
                          );

                          loadProfile();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}