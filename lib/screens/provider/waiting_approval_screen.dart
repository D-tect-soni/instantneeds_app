import 'package:flutter/material.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          "Verification Pending",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.hourglass_top,
                  size: 70,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Your Shop is Under Review",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Our team is reviewing your shop details.\nVerification usually takes 24 to 48 hours.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),
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
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Refresh Status",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
                    Icons.support_agent,
                    color: Colors.teal,
                  ),
                  label: const Text(
                    "Contact Support",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Support feature coming soon",
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Thank you for choosing InstantNeeds Partner Program.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}