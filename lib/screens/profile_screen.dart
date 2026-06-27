import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;

  bool isLoading = true;

  final ImagePicker picker = ImagePicker();

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final response = await ApiService.getProfile();

      setState(() {
        user = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
Future<void> pickImage() async {
  final XFile? image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
  );

  if (image == null) return;

  setState(() {
    selectedImage = File(image.path);
  });

  final response =
      await ApiService.uploadProfileImage(
    selectedImage!,
  );

  if (response["image"] != null) {
    await loadProfile();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Profile photo updated successfully",
        ),
      ),
    );
  } else {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response["message"] ??
              "Upload failed",
        ),
      ),
    );
  }
}
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.teal,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 15),

           Stack(
  children: [
    CircleAvatar(
      radius: 55,
      backgroundColor: Colors.teal,
      backgroundImage:
          user?["profileImage"] != null &&
                  user!["profileImage"] != ""
              ? NetworkImage(
                  user!["profileImage"],
                )
              : null,
      child:
          user?["profileImage"] == null ||
                  user!["profileImage"] == ""
              ? const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                )
              : null,
    ),

    Positioned(
      bottom: 0,
      right: 0,
      child: InkWell(
        onTap: pickImage,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.teal,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ),
  ],
),
            const SizedBox(height: 20),

            Text(
              user?["name"] ?? "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              user?["email"] ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: const Text("Mobile Number"),
                subtitle: Text(user?["phone"]?.toString() ?? "Not Added"),
              ),
            ),

            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text("Location"),
                subtitle: Text(user?["address"]?.toString() ?? "Not Added"),
              ),
            ),

            Card(
              elevation: 3,
              child: const ListTile(
                leading: Icon(Icons.shopping_bag, color: Colors.orange),
                title: Text("Total Orders"),
                subtitle: Text("Coming Soon"),
              ),
            ),

            Card(
              elevation: 3,
              child: const ListTile(
                leading: Icon(Icons.verified_user, color: Colors.green),
                title: Text("Account Status"),
                subtitle: Text("Active"),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () async {
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile not loaded")),
                    );
                    return;
                  }

                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(user: user!),
                    ),
                  );

                  if (result == true) {
                    await loadProfile();
                  }
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: logout,
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 231, 226, 226),
                ),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
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
