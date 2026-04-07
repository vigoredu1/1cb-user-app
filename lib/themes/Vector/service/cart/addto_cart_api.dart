import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class AddToCartApiService {
  static Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
    required String vendorId,
  }) async {
    try {
      final token = await StorageHelper.getToken();
      final vendorId = await StorageHelper.getVendorId();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token is missing');
      }

      final url = Uri.parse(
          "${AppConstant.baseUrl}${AppConstant.addToCartUrl}$vendorId");

      final body = json.encode({
        'productId': productId,
        'quantity': quantity,
        'vendorId': vendorId,
      });

      print("Add to Cart API Request: $url");
      print("Request Body: $body");

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      final responseData = json.decode(response.body);
      // Handle successful response (status 200)
      if (response.statusCode == 200) {
        if (responseData['error'] != null) {
          // Case when product already in cart (200 but with error)
          return {
            'success': false,
            'message': responseData['error']['message'] ??
                'The product is already in the',
          };
        } else if (responseData['data'] != null &&
            responseData['data']['message'] != null) {
          // Successful addition
          return {
            'success': true,
            'message': responseData['data']['message'],
          };
        } else {
          // Generic success message if no specific message found
          return {
            'success': true,
            'message': 'Product added to cart successfully',
          };
        }
      } else {
        // Handle non-200 status codes
        if (responseData['error'] != null) {
          return {
            'success': false,
            'message': responseData['error']['message'] ?? " ",
          };
        } else {
          throw Exception(
              'Failed to add product to cart. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error in addToCart: $e');
      rethrow;
    }
  }
}
