import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteOrderService {
  static Future<bool> deleteOrder(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse(
        "${NexusAppConstant.baseUrl}/api/order/delete-order/$orderId",
      );

      print(url);

      final response = await http.delete(
        url,
        headers: {
          "Authorization": token ?? "",
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
      );

      final result = jsonDecode(response.body);

      print(response.body);
      print("${response.statusCode}. delete api responses");

      // ✅ SUCCESS CONDITION (FIX)
      if (response.statusCode == 200 &&
          result["error"] != null &&
          result["error"]["error"] == "orderDeleted") {
        return true;
      }

      return false;
    } catch (e) {
      print("Delete order error: $e");
      return false;
    }
  }
}
