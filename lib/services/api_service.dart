import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://10.93.37.57:5000";

  // Register User
  static Future register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login User
  static Future login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
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
      headers: {
        "Content-Type": "application/json",
      },
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
    final response = await http.get(
      Uri.parse("$baseUrl/api/orders"),
    );

    return jsonDecode(response.body);
  }

  // Get User Profile
  static Future getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/auth/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Update User Profile
  static Future updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.put(
      Uri.parse("$baseUrl/api/auth/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "address": address,
      }),
    );

    return jsonDecode(response.body);
  }
}