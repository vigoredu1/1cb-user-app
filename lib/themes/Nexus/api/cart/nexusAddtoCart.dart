import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';

enum CartAddResult { success, alreadyExists, notLoggedIn, error }

class CartApiService {
  static Future<CartAddResult> addToCart({
    required String vendorId,
    required String productId,
    required String image,
    required bool isImported,
    required int price,
    required int quantity,
    required String selectedColor,
    required String selectedSize,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token')?.trim();

      if (token == null || token.isEmpty) {
        return CartAddResult.notLoggedIn;
      }

      final url =
          '${NexusAppConstant.baseUrl}${NexusAppConstant.addToCartUrl}$vendorId';
      print('Add to Cart URL: $url');
      print('Token being sent: $token');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "vendorId": vendorId, // ✅ required inside body
          "productId": productId,
          "quantity": quantity,
          "price": price, // matches API field
          "selectedColor": selectedColor.isEmpty ? "default" : selectedColor,
          "selectedSize": selectedSize.isEmpty ? "Free" : selectedSize,
          "image": image,
          "is_imported": isImported, // ✅ boolean
        }),
      );

      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CartAddResult.success;
      }

      if (_isAuthenticationError(body, response.statusCode)) {
        await _clearUserSession(prefs);
        return CartAddResult.notLoggedIn;
      }

      if (body['error']?['message']?.toString().contains('already') == true) {
        return CartAddResult.alreadyExists;
      }

      if (response.statusCode == 401) {
        return CartAddResult.notLoggedIn;
      }

      return CartAddResult.error;
    } catch (e) {
      print('Add to cart exception: $e');
      return CartAddResult.error;
    }
  }

  static bool _isAuthenticationError(
    Map<String, dynamic> body,
    int statusCode,
  ) {
    if (statusCode == 401) {
      return true;
    }
    return body['error'] is Map<String, dynamic> &&
        body['error']['error'] == 'FailedToAuthenticate';
  }

  static Future<void> _clearUserSession(SharedPreferences prefs) async {
    const keys = [
      'token',
      'auth_token',
      'email',
      'name',
      'mobile',
      'profile_picture',
      'role',
      'guestId',
    ];
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
