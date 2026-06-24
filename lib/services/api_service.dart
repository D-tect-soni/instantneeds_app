import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.194.130.57:5000";

  // Register User
  static Future register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // Login User
  static Future login({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return jsonDecode(response.body);
  }

  // Create Order
  static Future createOrder({
    required String serviceName,
    required String address,
    required int quantity,
    required int amount,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/orders"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "serviceName": serviceName,
        "address": address,
        "quantity": quantity,
        "amount": amount,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get Orders
  static Future getOrders() async {
    final response = await http.get(Uri.parse("$baseUrl/api/orders"));

    return jsonDecode(response.body);
  }
}
