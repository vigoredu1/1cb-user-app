import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Modules/profile/AmzCancellationPolicy.dart';

class CancellationPolicyService {
  static const String _baseUrl =
      '${AmzAppConstant.baseUrl}${AmzAppConstant.cancellation_Url}';

  static Future<CancellationPolicyData?> fetchPolicy(String vendorId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Auth token missing');
    }

    final url = Uri.parse('$_baseUrl/$vendorId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    print('${response.statusCode}');
        print('${response.body}');

    

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final policyResponse =
          CancellationPolicyResponse.fromJson(jsonData);
      return policyResponse.data;
    } else {
      throw Exception('Failed to load cancellation policy');
    }
  }
}
