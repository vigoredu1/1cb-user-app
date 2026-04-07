import 'dart:convert';

import '../../../utility/app_constant.dart';
import '../../../utility/local_storage.dart';
import 'package:http/http.dart' as http;

import '../added_pages_model.dart';
Future<PageServiceModel?> getPageContent(String endpoint) async {
  final vendorId = await StorageHelper.getVendorId();
  String url = "${AppConstant.baseUrl}$endpoint$vendorId";

  print("API URL ----> $url");

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return PageServiceModel.fromJson(decoded["data"]);
    } else {
      print("API Error Status Code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Page API Error: $e");
    return null;
  }
}
