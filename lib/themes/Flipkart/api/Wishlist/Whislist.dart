import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/Modules/wishlist/nexusproductWhislist.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WishlistService {

  Future<WishlistResponse?> getWishlist(String vendorId) async {

    try {

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        print("⚠️ Wishlist: Token not found");
        return null;
      }

      final url = "https://api.1clickbuilder.com/api/wishlist/$vendorId";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization":token,
        },
      );

      print("📦 Wishlist Status: ${res.statusCode}");
      print("📦 Wishlist Body: ${res.body}");

      if (res.statusCode == 200) {

        final body = jsonDecode(res.body);

        return WishlistResponse.fromJson(body);
      }

      if (res.statusCode == 401) {
        print("❌ Token expired or invalid");
      }

      return null;

    } catch (e, stack) {

      print("🚨 Wishlist Exception: $e");
      print(stack);

      return null;
    }
  }
}