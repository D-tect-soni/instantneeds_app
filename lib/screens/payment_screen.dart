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
      'key': 'rzp_test_T5Z148SqKauCOT',
      'amount':  100,
      'name': 'InstantNeeds',
      'description': 'Service Booking',
      'timeout': 300,

      'prefill': {
        'contact': '9999999999',
        'email': 'devansh@gmail.com'
      },

      'theme': {
        'color': '#009688'
      },

      'retry': {
        'enabled': true,
        'max_count': 1
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Checkout Error: $e",
          ),
        ),
      );
    }
  }

  void _handlePaymentSuccess(
    PaymentSuccessResponse response,
  ) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "Payment Success\n${response.paymentId}",
        ),
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

    print(
        "ERROR CODE = ${response.code}");
    print(
        "ERROR MESSAGE = ${response.message}");

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        duration:
            const Duration(seconds: 5),
        content: Text(
          "Code: ${response.code}\nMessage: ${response.message}",
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
          "Wallet: ${response.walletName}",
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
          style: TextStyle(
            color: Colors.white,
          ),
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