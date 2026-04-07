import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';

class PaymentService {

  /// 🔹 Get Delivery Types (cod / prepaid)
  Future<List<String>> getDeliveryTypes(String vendorId) async {
    final url =
        "${NexusAppConstant.baseUrl}/api/payment-gateway/delivery-type/$vendorId";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
        },
      );

      print("📡 DeliveryType Status: ${response.statusCode}");
      print("📦 DeliveryType Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final List<String> types =
            List<String>.from(jsonData["data"]["deliveryType"]);

        return types;
      }

      return ["cod"]; // fallback
    } catch (e) {
      print("❌ DeliveryType Error: $e");
      return ["cod"]; // fallback
    }
  }
}
