import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int amount;

  const PaymentScreen({
    super.key,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState
    extends State<PaymentScreen> {

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
  }

  void openCheckout() {

    var options = {
      'key': 'rzp_test_T5XBMusISbtfkk',
      'amount': widget.amount * 100,
      'name': 'InstantNeeds',
      'description': 'Service Booking',
      'prefill': {
        'contact': '9999999999',
        'email': 'devansh@gmail.com'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text("Payment Successful"),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const OrderSuccessScreen(),
      ),
    );
  }

  void _handlePaymentError(
    PaymentFailureResponse response,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "Payment Failed: ${response.message}",
        ),
      ),
    );
  }

  void _handleExternalWallet(
    ExternalWalletResponse response,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "External Wallet: ${response.walletName}",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Payment",
          style:
              TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 30),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        15),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Column(
                children: [

                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.teal,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Amount To Pay",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹${widget.amount}",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.teal,
                ),
                onPressed: openCheckout,
                child: const Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}