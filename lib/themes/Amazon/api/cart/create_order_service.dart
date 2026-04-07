import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/app_constant.dart';

class CreateOrderService {
  static final String _url = "${AmzAppConstant.baseUrl}/api/order/create-order";

  static Future<Map<String, dynamic>?> createOrder({
    required String vendorId,
    required String paymentMethod,
    required String shippingMethod,
    required List<Map<String, dynamic>> orderItems,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
    double discount = 0,
    double ship = 0,
    bool showSnackbar = true,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token")?.trim();

      final body = {
        "order": {
          "vendor_id": vendorId,
          "payment_method": paymentMethod,
          "shipping_method": shippingMethod,
          "status": "Pending",
          "discount": discount,
          "ship": ship,
        },
        "orderItems": orderItems,
        "billingAddress": billingAddress,
        "shippingAddress": shippingAddress,
      };

      final res = await http.post(
        Uri.parse(_url),
        headers: {
          "Content-Type": "application/json",
          if (token != null && token.isNotEmpty) "Authorization": token,
        },
        body: jsonEncode(body),
      );
      final dynamic decodedBody = jsonDecode(res.body);
      final Map<String, dynamic> decoded = decodedBody is Map<String, dynamic>
          ? decodedBody
          : <String, dynamic>{};

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (showSnackbar) {
          Get.snackbar("Success", "Order placed successfully!");
        }

        final data = decoded["data"];
        return data is Map<String, dynamic> ? data : null;
      }

      Get.snackbar(
        "Order Failed",
        _extractErrorMessage(decoded) ??
            "Unable to place order. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    }
  }

  static String? _extractErrorMessage(Map<String, dynamic> decoded) {
    final error = decoded["error"];
    if (error is String && error.isNotEmpty) {
      return error;
    }
    if (error is Map<String, dynamic>) {
      final message = error["message"];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    final data = decoded["data"];
    if (data is Map<String, dynamic>) {
      final message = data["message"];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }
}

// class CreateOrderService {
//   static  final String _url =
//       "${NexusAppConstant.baseUrl}/api/order/create-order";
// static Future<bool> createOrder({
//   required String vendorId,
//   required String paymentMethod,
//   required String shippingMethod,
//   required List<Map<String, dynamic>> orderItems,
//   required Map<String, dynamic> billingAddress,
//   required Map<String, dynamic> shippingAddress,
//   double discount = 0,
//   double ship = 0,
//   bool showSnackbar = true,
// }) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");

//     final body = {
//       "order": {
//         "vendor_id": vendorId,
//         "payment_method": paymentMethod.toUpperCase(), // FIXED
//         "shipping_method": shippingMethod,
//         "status": "Pending",
//         "discount": discount,
//         "ship": ship,
//       },
//       "orderItems": orderItems.map((item) => {
//         "product_id": item["product_id"],
//         "productImageId": item["productImageId"],
//         "quantity": item["quantity"],
//         "price": item["price"],
//       }).toList(),
//       "billingAddress": billingAddress,
//       "shippingAddress": shippingAddress,
//     };

//     final res = await http.post(
//       Uri.parse(_url),
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "*/*",
//         if (token != null) "Authorization": "$token",
//       },
//       body: jsonEncode(body),
//     );

//     print("📡 STATUS: ${res.statusCode}");
//     print("📦 BODY: ${res.body}");

//    if (res.statusCode == 200 || res.statusCode == 201) {
//       Get.snackbar("Success", "Order placed successfully!");

//   return true;
// } else {
//   Get.snackbar(
//     "Order Failed",
//     "Unable to place order. Please try again.",
//     backgroundColor: Colors.redAccent,
//     colorText: Colors.white,
//   );
//   return false;
// }

//   }

// catch (e) {
//   Get.snackbar(
//     "Error",
//     "Something went wrong. Please try again.",
//     backgroundColor: Colors.redAccent,
//     colorText: Colors.white,
//   );
//   return false;
// }

// }

// }
