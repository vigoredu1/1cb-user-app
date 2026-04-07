import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Amazon/Modules/orders/orderDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';

import '../../Modules/orders/orderDetails.dart';

class ShiprocketOrderApi {
  static Future<ShiprocketOrderResponse> fetchOrderDetails(
      String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url =
        "${AmzAppConstant.baseUrl}/api/shiprocket/get-order-details/$orderId";

    print("📦 details order id => $url");
    print("🔐 token length => ${token.length}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'accept': 'application/json, text/plain, */*',
        'authorization': token,
      },
    );

    print("📥 status => ${response.statusCode}");
    print("📥 body => ${response.body}");

    if (response.statusCode == 200) {
      return ShiprocketOrderResponse.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        "Failed to load order details (${response.statusCode})",
      );
    }
  }
}

