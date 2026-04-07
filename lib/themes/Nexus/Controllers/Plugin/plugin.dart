import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PluginController extends GetxController {

  RxInt twofactor = 0.obs;

  Future<void> fetchPlugins(String vendorId) async {
    final response = await http.get(
      Uri.parse("https://api.1clickbuilder.com/api/plugin/get-plugin/$vendorId"),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded["data"] != null) {
      twofactor.value = decoded["data"]["twofactor"] ?? 0;

      print("Two Factor Value: ${twofactor.value}");
    }
  }
}