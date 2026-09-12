import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ReviewScreen extends StatefulWidget {
  final String orderId;
  final String providerId;

  const ReviewScreen({
    super.key,
    required this.orderId,
    required this.providerId,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int rating = 5;
  bool isLoading = false;

  final TextEditingController reviewController = TextEditingController();

  Future<void> submitReview() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.submitReview(
        orderId: widget.orderId,
        providerId: widget.providerId,
        rating: rating,
        review: reviewController.text.trim(),
      );

      if (!mounted) return;

      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Review Submitted Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "Something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 38,
      ),
      onPressed: () {
        setState(() {
          rating = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Your Experience"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.rate_review, size: 90, color: Colors.teal),

            const SizedBox(height: 20),

            const Text(
              "How was your service?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Please rate the provider and write your feedback.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => buildStar(index + 1)),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Submit Review",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}
