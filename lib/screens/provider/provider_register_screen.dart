import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/api_service.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() =>
      _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState
    extends State<ProviderRegisterScreen> {

  // =========================
  // Controllers
  // =========================

  final shopNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final experienceController = TextEditingController();
  final descriptionController = TextEditingController();

  // =========================
  // Location
  // =========================

  double? latitude;
  double? longitude;

  bool isLoading = false;

  String selectedCategory = "Laundry";

  final List<String> categories = [
    "Laundry",
    "Electrician",
    "Plumber",
    "Painter",
    "Carpenter",
    "AC Repair",
    "Salon",
    "Home Cleaning",
    "Pest Control",
    "Car Wash",
  ];

  // =========================
  // Get Current Location
  // =========================

  Future<void> getCurrentLocation() async {

    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        "Please turn on GPS Location",
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        "Location Permission Denied",
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {

      await Geolocator.openAppSettings();

      throw Exception(
        "Please allow location permission",
      );
    }

    Position position =
        await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

    debugPrint(
      "Latitude : $latitude",
    );

    debugPrint(
      "Longitude : $longitude",
    );
  }
    
    // =========================
  // Register Shop
  // =========================

  Future<void> registerShop() async {
    debugPrint("REGISTER SCREEN BUTTON CLICKED");
    if (shopNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        pincodeController.text.isEmpty ||
        experienceController.text.isEmpty ||
        descriptionController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      // Get Current Location
      await getCurrentLocation();

      final response = await ApiService.registerShop(
        shopName: shopNameController.text.trim(),
        category: selectedCategory,
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        description: descriptionController.text.trim(),
        experience:
            int.tryParse(
                  experienceController.text.trim(),
                ) ??
                0,
        latitude: latitude!,
        longitude: longitude!,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (response["shop"] != null) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Shop Registered Successfully 🎉",
            ),
          ),
        );

        Navigator.pop(context);

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response["message"] ??
                  "Registration Failed",
            ),
          ),
        );

      }

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
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Become a Service Provider",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: shopNameController,
              decoration: const InputDecoration(
                labelText: "Shop Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: stateController,
              decoration: const InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: pincodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Pincode",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Experience (Years)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
                        SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: isLoading
                    ? null
                    : registerShop,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Register Shop",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}