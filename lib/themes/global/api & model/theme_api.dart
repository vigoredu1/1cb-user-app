import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/global/api%20&%20model/theme_model.dart';

// class ThemeService {
//   static const String baseUrl = "https://api.1clickbuilder.com/api/logo/logo/";

//   static Future<ThemeModel?> getThemeData(String domain) async {
//     try {
//       final url = Uri.parse("$baseUrl$domain");

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         return ThemeModel.fromJson(json.decode(response.body));
//       } else {
//         print("Error: ${response.statusCode}");
//         return null;
//       }

//     } catch (e) {
//       print("Exception: $e");
//       return null;
//     }
//   }
// }


class ThemeService {
  static const String baseUrl = 'https://api.1clickbuilder.com/api/logo/logo/';

  static Future<ThemeModel?> getThemeData(String domain) async {
    try {
      final url = Uri.parse('$baseUrl$domain');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return ThemeModel.fromJson(json.decode(response.body));
      } else {
        debugPrint('ThemeService error: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('ThemeService exception: $e');
      return null;
    }
  }
}

