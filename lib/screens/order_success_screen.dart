import 'package:flutter/material.dart';
import 'home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
const OrderSuccessScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,

  body: Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 120,
          ),

          const SizedBox(height: 20),

          const Text(
            "Order Placed Successfully 🎉",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Your service provider will contact you shortly.",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const HomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                "Back To Home",
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
