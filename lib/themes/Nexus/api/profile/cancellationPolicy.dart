import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/Modules/profile/Nexus%20CancellationPolicy.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancellationPolicyService {
  static const String _baseUrl =
      '${NexusAppConstant.baseUrl}${NexusAppConstant.cancellation_Url}';

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
        print(response.body);

    

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
