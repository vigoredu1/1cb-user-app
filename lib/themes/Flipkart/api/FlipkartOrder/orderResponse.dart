import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/orders/NexusOrders.dart';
import 'package:one_click_builder/themes/Flipkart/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderApi {
  static String baseUrl = "${FlipkartAppConstant.baseUrl}/api/order";

  static Future<OrderApiResponse> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      print(".     details.     $token");

      if (token == null || token.isEmpty) {
        throw Exception("Auth token not found");
      }

      final vendorController = Get.find<FlipkartVendorController>();
      final vendorId = vendorController.vendorId.value;

      if (vendorId.isEmpty) {
        throw Exception("Vendor ID not found");
      }

      print(".     details.     $baseUrl/$vendorId");

      final response = await http.get(
        Uri.parse("$baseUrl/$vendorId"),
        headers: {
          "Authorization": token,
          "Content-Type": "application/json",
        },
      );

      print("📡 STATUS: ${response.statusCode}");
      print("📦 BODY.   recent orders : ${response.body}");

      if (response.statusCode == 200) {
        return OrderApiResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception("API Error ${response.statusCode}");
      }
    } catch (e, stack) {
      print("❌ FETCH ORDERS ERROR: $e");
      print("🧵 STACK TRACE:\n$stack");
      rethrow;
    }
  }
}
