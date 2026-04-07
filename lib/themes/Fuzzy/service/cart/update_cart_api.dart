import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class UpdateCartApiService {
  static Future<Map<String, dynamic>> UpdateToCart({
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
          "${AppConstant.baseUrl}${AppConstant.update_cartUrl}$vendorId");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode({
          'productId': productId,
          'quantity': quantity,
          'vendorId': vendorId,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message':
              responseData['data']['message'] ?? 'Cart updated successfully',
        };
      } else {
        throw Exception(
            responseData['error']['message'] ?? 'Failed to update cart');
      }
    } catch (e) {
      print('Error updating cart: $e');
      rethrow;
    }
  }
}
