import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlipkartAuthService {
  Future<String?> login({
    required String input,
    required String password,
    String? vendorId,
  }) async {
    try {
      final bool isEmail = input.contains('@');
      final String normalizedMobile = input.replaceAll(RegExp(r'[^0-9]'), '');
      final body = <String, dynamic>{
        "password": password,
      };
      if (isEmail) {
        body["email"] = input.trim();
      } else {
        body["mobile"] = normalizedMobile;
      }
      if (vendorId != null && vendorId.trim().isNotEmpty) {
        body["vendorId"] = vendorId.trim();
      }

      final response = await http.post(
        Uri.parse(
          "${FlipkartAppConstant.baseUrl}${FlipkartAppConstant.loginUrl}",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final dynamic decodedBody = jsonDecode(response.body);
      final Map<String, dynamic> decoded = decodedBody is Map<String, dynamic>
          ? decodedBody
          : <String, dynamic>{};

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decoded['error'] == null && decoded['data'] != null) {
          final data = decoded['data'];
          final user = data['user'];

          final prefs = await SharedPreferences.getInstance();

//          await prefs.setString('user_id', data['id']);
          await prefs.setString('token', data['token']);
          await prefs.setString('email', user['email'] ?? '');
          await prefs.setString('name', user['firstName'] ?? '');
          await prefs.setString('mobile', user['mobile'] ?? '');
          await prefs.setString(
              'profile_picture', user['profilePicture'] ?? '');
          await prefs.setString('role', user['role'] ?? '');

          return null;
        }
      }

      return _extractErrorMessage(decoded) ?? 'Invalid credentials';
    } catch (_) {
      return 'Unable to login right now. Please try again.';
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> decoded) {
    final error = decoded['error'];
    if (error is String && error.isNotEmpty) {
      return error;
    }
    if (error is Map<String, dynamic>) {
      final message = error['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }
}
