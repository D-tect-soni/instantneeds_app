import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'dart:io';
import '../../services/image_picker_service.dart';
import 'package:geolocator/geolocator.dart';

class ProviderSetupScreen extends StatefulWidget {
  const ProviderSetupScreen({super.key});

  @override
  State<ProviderSetupScreen> createState() => _ProviderSetupScreenState();
}

class _ProviderSetupScreenState extends State<ProviderSetupScreen> {
  // Controllers
  final shopNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final experienceController = TextEditingController();
  File? shopLogo;
  double? latitude;
  double? longitude;
  String selectedCategory = "Laundry";

  bool isLoading = false;

  TimeOfDay? openingTime;
  TimeOfDay? closingTime;

  Future<void> selectOpeningTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        openingTime = picked;
      });
    }
  }

  Future<void> selectClosingTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        closingTime = picked;
      });
    }
  }
  Future<void> getCurrentLocation() async {

  bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception("Please turn on GPS");
  }

  LocationPermission permission =
      await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission =
        await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception("Location Permission Denied");
  }

  if (permission ==
      LocationPermission.deniedForever) {

    await Geolocator.openAppSettings();

    throw Exception("Allow Location Permission");
  }

  Position position =
      await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  debugPrint(
    "Lat: ${position.latitude}, Lng: ${position.longitude}");

  latitude = position.latitude;
  longitude = position.longitude;
}

  Future<void> registerBusiness() async {
    debugPrint("SETUP SCREEN BUTTON CLICKED");
    if (shopNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        pincodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      debugPrint("Calling getCurrentLocation()");
      await getCurrentLocation();
      debugPrint("Inside getCurrentLocation()");
      final response = await ApiService.registerShop(
        shopName: shopNameController.text.trim(),
        category: selectedCategory,
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        description: descriptionController.text.trim(),
        experience: int.tryParse(experienceController.text) ?? 0,
        latitude: latitude!,
        longitude: longitude!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ?? "Business Registered Successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickLogo() async {
    final image = await ImagePickerService.pickImageFromGallery();

    if (image == null) return;

    setState(() {
      shopLogo = image;
    });

    try {
      final response = await ApiService.uploadShopLogo(image);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ?? "Shop Logo Uploaded Successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Provider Registration"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Become an InstantNeeds Partner",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Fill your business information below.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: shopNameController,
              decoration: const InputDecoration(
                labelText: "Shop Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedCategory,

              decoration: const InputDecoration(
                labelText: "Business Category",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),

              items: const [
                DropdownMenuItem(value: "Laundry", child: Text("Laundry")),

                DropdownMenuItem(
                  value: "Water Supply",
                  child: Text("Water Supply"),
                ),

                DropdownMenuItem(value: "Printing", child: Text("Printing")),

                DropdownMenuItem(value: "Food", child: Text("Food")),

                DropdownMenuItem(
                  value: "Electrician",
                  child: Text("Electrician"),
                ),

                DropdownMenuItem(value: "Plumber", child: Text("Plumber")),

                DropdownMenuItem(value: "Carpenter", child: Text("Carpenter")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 3,

              decoration: const InputDecoration(
                labelText: "Business Description",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: shopLogo != null
                        ? FileImage(shopLogo!)
                        : null,
                    child: shopLogo == null
                        ? const Icon(Icons.store, size: 45, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed: pickLogo,
                    icon: const Icon(Icons.photo),
                    label: const Text("Upload Shop Logo"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: experienceController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Experience (Years)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work_history),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,

              decoration: const InputDecoration(
                labelText: "Business Phone",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: addressController,
              maxLines: 2,

              decoration: const InputDecoration(
                labelText: "Business Address",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: cityController,

              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: stateController,

              decoration: const InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: pincodeController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: "Pincode",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.pin_drop),
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),

            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: selectOpeningTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      openingTime == null
                          ? "Opening Time"
                          : openingTime!.format(context),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: selectClosingTime,
                    icon: const Icon(Icons.access_time_filled),
                    label: Text(
                      closingTime == null
                          ? "Closing Time"
                          : closingTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : registerBusiness,

                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.store, color: Colors.white),

                label: Text(
                  isLoading ? "Please Wait..." : "Register Business",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    shopNameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    experienceController.dispose();
    super.dispose();
  }
}
