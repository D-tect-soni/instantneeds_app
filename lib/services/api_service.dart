import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class ApiService {
static const String baseUrl = "http://192.168.1.15:5000";
  // Register User
  static Future register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      }),
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
    required String shopId,
    required String serviceName,
    required String address,
    required int quantity,
    required int amount,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl/api/orders"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "shopId": shopId,
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
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/orders"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
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
      body: jsonEncode({"name": name, "phone": phone, "address": address}),
    );

    return jsonDecode(response.body);
  }

  // Upload Profile Imageq
  static Future uploadProfileImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/auth/upload-profile-image"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        imageFile.path,
        contentType: MediaType("image", "jpeg"),
      ),
    );

    var response = await request.send();

    var responseData = await response.stream.bytesToString();

    return jsonDecode(responseData);
  }

  // Register Shop
  static Future registerShop({
    required String shopName,
    required String category,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String description,
    required int experience,
    required double latitude,
    required double longitude,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl/api/shop/register"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "shopName": shopName,
        "category": category,
        "phone": phone,
        "address": address,
        "city": city,
        "state": state,
        "pincode": pincode,
        "description": description,
        "experience": experience,
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    return jsonDecode(response.body);
  }

  // Upload Shop Logo
  static Future uploadShopLogo(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/api/shop/upload-logo"),
    );

    request.headers["Authorization"] = "Bearer $token";

    request.files.add(
      await http.MultipartFile.fromPath(
        "image",
        imageFile.path,
        contentType: MediaType("image", "jpeg"),
      ),
    );

    var response = await request.send();

    var responseData = await response.stream.bytesToString();

    return jsonDecode(responseData);
  }

  // Get Nearby Shops
  static Future getNearbyShops({
    required String category,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/api/shop/nearby"
        "?category=$category"
        "&latitude=$latitude"
        "&longitude=$longitude",
      ),
    );

    return jsonDecode(response.body);
  }

  // Get Provider Status
  static Future getProviderStatus() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/shop/provider-status"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Get My Shop
  static Future getMyShop() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/shop/my-shop"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Provider Dashboard
  static Future getProviderDashboard() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/orders/provider/dashboard"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Accept Order
  static Future acceptOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.patch(
      Uri.parse("$baseUrl/api/orders/$orderId/accept"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Reject Order
  static Future rejectOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.patch(
      Uri.parse("$baseUrl/api/orders/$orderId/reject"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Complete Order
  static Future completeOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.patch(
      Uri.parse("$baseUrl/api/orders/$orderId/complete"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Provider Earnings
  static Future getProviderEarnings() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse("$baseUrl/api/orders/provider/earnings"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Update Shop
  static Future updateShop(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.put(
      Uri.parse("$baseUrl/api/shop/update"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  // Submit Review
  static Future submitReview({
    required String orderId,
    required String providerId,
    required int rating,
    required String review,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("$baseUrl/api/reviews"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "orderId": orderId,
        "providerId": providerId,
        "rating": rating,
        "review": review,
      }),
    );

    return jsonDecode(response.body);
  }

  // Get Provider Reviews
  static Future getProviderReviews(String providerId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/reviews/provider/$providerId"),
    );

    return jsonDecode(response.body);
  }

  // Get Provider Average Rating
  static Future getAverageRating(String providerId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/reviews/provider/$providerId/average"),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/forgot-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> resetPassword({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse("$baseUrl/api/auth/reset-password"),
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
}
