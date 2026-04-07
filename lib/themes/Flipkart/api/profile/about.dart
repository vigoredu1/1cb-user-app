import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/Modules/profile/aboutUs.dart';
import 'package:one_click_builder/themes/Flipkart/utility/plugin_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutService {
  static Future<AboutResponse> fetchAbout(String vendorId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Auth token missing');
    }

    final String url =
        "https://api.1clickbuilder.com/api/page-service/about/$vendorId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return AboutResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Failed to load about content (${response.statusCode})",
      );
    }
  }
}

