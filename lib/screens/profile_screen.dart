import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
const ProfileScreen({super.key});

Future<void> logout(BuildContext context) async {
final prefs =
await SharedPreferences.getInstance();


await prefs.remove("token");

Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => const LoginScreen(),
  ),
  (route) => false,
);

}

@override
Widget build(BuildContext context) {

return Scaffold(
  appBar: AppBar(
    title: const Text("Profile"),
    backgroundColor: Colors.teal,
  ),
  body: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [

        const CircleAvatar(
          radius: 45,
          child: Icon(
            Icons.person,
            size: 50,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Devansh",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "devansh@gmail.com",
        ),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () =>
                logout(context),
            icon:
                const Icon(Icons.logout),
            label: const Text(
              "Logout",
            ),
          ),
        ),
      ],
    ),
  ),
);

}
}
