import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isSaving = false;

  File? selectedImage;

  final shopNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final experienceController = TextEditingController();
  final openingController = TextEditingController();
  final closingController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = "";
  String logo = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final shop = await ApiService.getMyShop();

      shopNameController.text = shop["shopName"] ?? "";
      phoneController.text = shop["phone"] ?? "";
      addressController.text = shop["address"] ?? "";
      cityController.text = shop["city"] ?? "";
      stateController.text = shop["state"] ?? "";
      pincodeController.text = (shop["pincode"] ?? "").toString();
      experienceController.text = (shop["experience"] ?? "").toString();
      openingController.text = shop["openingTime"] ?? "";
      closingController.text = shop["closingTime"] ?? "";
      descriptionController.text = shop["description"] ?? "";

      category = shop["category"] ?? "";
      logo = shop["shopLogo"] ?? "";
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    setState(() {
      selectedImage = File(picked.path);
    });
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      // Upload logo if selected
      if (selectedImage != null) {
        final result = await ApiService.uploadShopLogo(selectedImage!);

        print(result);

        if (result["success"] == true) {
          logo = result["logo"];
        }
      }

      await ApiService.updateShop({
        "shopName": shopNameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "experience": experienceController.text.trim(),
        "openingTime": openingController.text.trim(),
        "closingTime": closingController.text.trim(),
        "description": descriptionController.text.trim(),
        "shopLogo": logo,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }

    if (mounted) {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    shopNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    experienceController.dispose();
    openingController.dispose();
    closingController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.teal.shade100,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (logo.isNotEmpty
                                ? NetworkImage(logo) as ImageProvider
                                : null),
                      child: selectedImage == null && logo.isEmpty
                          ? const Icon(
                              Icons.store,
                              size: 50,
                              color: Colors.teal,
                            )
                          : null,
                    ),

                    const SizedBox(height: 15),

                    OutlinedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text("Change Shop Logo"),
                    ),

                    const SizedBox(height: 25),

                    TextFormField(
                      controller: shopNameController,
                      decoration: const InputDecoration(
                        labelText: "Shop Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Enter Shop Name" : null,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      initialValue: category,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: "City",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: "State",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Pincode",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: experienceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Experience (Years)",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: openingController,
                      decoration: const InputDecoration(
                        labelText: "Opening Time",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: closingController,
                      decoration: const InputDecoration(
                        labelText: "Closing Time",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        onPressed: isSaving ? null : saveProfile,
                        child: isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
