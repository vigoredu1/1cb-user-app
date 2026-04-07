import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../data/model/cart/cart_model.dart';
import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class CartApiService {
  static Future<CartResponse> fetchCart() async {
    try {
      final vendorId = await StorageHelper.getVendorId();
      final token = await StorageHelper.getToken();

      if (vendorId == null || vendorId.isEmpty) {
        throw Exception('Vendor ID is missing');
      }

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      final url =
          Uri.parse("${AppConstant.baseUrl}${AppConstant.catUrl}$vendorId");
      print("Making API request to: $url");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      ).timeout(const Duration(seconds: 30));

      // print("API Response Status: ${response.statusCode}");
      // print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['data'] == null) {
          throw Exception('No cart data found in response');
        }
        if (response.statusCode == 404) {
          throw Exception(
              'Cart not found (404). Please check the endpoint URL.');
        }

        return CartResponse.fromJson(responseData['data']);
      } else {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['error'] ?? 'Failed to load cart';
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      print('ClientException during fetchCart: $e');
      throw Exception('Network error occurred. Please check your connection.');
    }
  }
  static Future<void> removeCartItem(List<String> productIds) async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      // Assuming vendorId is still needed; if not, remove it
      final vendorId = await StorageHelper.getVendorId();

      // Prepare the products list in the required format
      final products = productIds.map((id) => {
        "productId": id,
        "vendorId": vendorId,  // Adjust if vendor_id is per product
      }).toList();

      final url = Uri.parse('${AppConstant.baseUrl}${AppConstant.remove_cartUrl}');
      print("Making DELETE request to: $url");

      final response = await http.delete(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',  // Add this for JSON body
        },
        body: json.encode({"products": products}),  // Send products in body
      ).timeout(const Duration(seconds: 30));

      print("DELETE Response Status: ${response.statusCode}");
      print("DELETE Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Items removed from cart successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        print("else part here");
        print("Error here: ${response.statusCode}");
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['error'] ?? 'Failed to remove items';
        Get.snackbar(
          "Failed",
          "Something went wrong. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } on http.ClientException catch (e) {
      print('ClientException during removeCartItem: $e');
      Get.snackbar(
        "Error ❌",
        "Network error occurred. Please check your connection.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print('Exception during removeCartItem: $e');
      Get.snackbar(
        "Error ❌",
        "Something went wrong. Please try again later.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  // static Future<void> removeCartItem(String productId) async {
  //   try {
  //     final token = await StorageHelper.getToken();
  //     final vendorId = await StorageHelper.getVendorId();
  //
  //     if (token == null || token.isEmpty) {
  //       throw Exception('Authentication token is missing');
  //     }
  //
  //     final url = Uri.parse(
  //         '${AppConstant.baseUrl}${AppConstant.remove_cartUrl}$productId/$vendorId');
  //     print("Making DELETE request to: $url");
  //
  //     final response = await http.delete(
  //       url,
  //       headers: {'Authorization': token},
  //     ).timeout(const Duration(seconds: 30));
  //
  //     print("DELETE Response Status: ${response.statusCode}");
  //     print("DELETE Response Body: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       Get.snackbar(
  //         "Success",
  //         "Item removed from cart successfully",
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.TOP,
  //       );
  //     } else {
  //       print("else part here");
  //       print("Error here: ${response.statusCode}");
  //       final errorResponse = json.decode(response.body);
  //       final errorMessage = errorResponse['error'] ?? 'Failed to remove item';
  //       Get.snackbar(
  //         "Failed",
  //         "Something went wrong. Please try again.",
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //         snackPosition: SnackPosition.TOP,
  //       );
  //     }
  //   } on http.ClientException catch (e) {
  //     print('ClientException during removeCartItem: $e');
  //     Get.snackbar(
  //       "Error ❌",
  //       "Network error occurred. Please check your connection.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.TOP,
  //     );
  //   } catch (e) {
  //     print('Exception during removeCartItem: $e');
  //     Get.snackbar(
  //       "Error ❌",
  //       "Something went wrong. Please try again later.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.TOP,
  //     );
  //   }
  // }
}
