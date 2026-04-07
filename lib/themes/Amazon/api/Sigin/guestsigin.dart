import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future guestLogin(String vendorId) async {
  const String url = "${AmzAppConstant.baseUrl}/api/user/guest-login";

  final Map<String, dynamic> body = {
    "vendorId": vendorId,
  };

  try {
    // Get existing guestId
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? existingGuestId = prefs.getString("guestId");

    // 🔥 If already saved → do not call API again
    if (existingGuestId != null && existingGuestId.isNotEmpty) {
      print("Guest ID already exists, skipping API call: $existingGuestId");
      return existingGuestId;
    }

    // 🔥 Otherwise call guest login API
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      String newGuestId = data["data"]["id"];

      // Save only when not present
      await prefs.setString("guestId", newGuestId);
      print("Guest ID saved: $newGuestId");

      print("Guest Login Successful");
      return newGuestId;
    } else {
      print("Login failed: ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
