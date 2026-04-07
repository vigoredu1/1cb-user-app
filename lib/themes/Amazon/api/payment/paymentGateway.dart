import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentGatewayService {
  static Future<Map<String, dynamic>?> getActiveGateway(
    String vendorId,
  ) async {
    final url = "https://api.1clickbuilder.com/api/payment-gateway/$vendorId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is! Map<String, dynamic>) {
          return null;
        }

        final List<dynamic> gateways =
            decoded["data"] is List ? decoded["data"] as List<dynamic> : [];

        if (gateways.isEmpty) return null;

        final activeList = gateways.where((gateway) {
          final status = gateway["status"];
          return status == 1 || status == "1" || status == true;
        }).toList();

        if (activeList.isEmpty) {
          return null;
        }

        final activeGateway = activeList.first;

        print("✅ Active Gateway: ${activeGateway["title"]}");

        return {
          "title": activeGateway["title"],
          "apiKey": activeGateway["apiKey"],
          "secretKey": activeGateway["secretKey"],
          "mode": activeGateway["mode"],
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
