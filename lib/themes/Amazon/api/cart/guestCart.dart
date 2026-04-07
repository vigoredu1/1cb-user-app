import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestCartService {
  static  String baseUrl = "${AmzAppConstant.baseUrl}/api/cart/guest";

  /// Fetch guest cart list
static Future<Map<String, dynamic>?> fetchGuestCart() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final guestId = prefs.getString("guestId") ?? "";
    final vendorId = prefs.getString("vendor_id") ?? "";

    if (guestId.isEmpty || vendorId.isEmpty) {
      print("⚠ Missing vendorId or guestId");
      return null;
    }

    final url = "$baseUrl/$vendorId/$guestId";
    print("🔗 API: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["data"];   // RETURN MAP (cart + items)
    } else {
      print("❌ Error: ${response.body}");
      return null;
    }
  } catch (e) {
    print("🔥 Exception: $e");
    return null;
  }
}


  /// Fetch only guest cart count
 static Future<int> getGuestCartCount() async {
  final data = await fetchGuestCart();
  return (data?["items"]?.length ?? 0);
}

}
