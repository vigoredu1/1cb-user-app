import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Amazon/Modules/AmzProducts/AmzProduct.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
class ProductService {

 Future<ProductListResponse?> getProducts(
  String vendorId, {
  required int page,
  required int limit,
})
  async {

    final url =
        "${AmzAppConstant.baseUrl}${AmzAppConstant.product_list}$vendorId?page=$page&limit=$limit";

    debugPrint("🟡 PRODUCT API URL: $url");

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 45));

      debugPrint("🟢 STATUS CODE: ${response.statusCode}");
      debugPrint("🟢 RAW RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final parsed = productListResponseFromJson(response.body);
        debugPrint("🟢 PARSED PRODUCTS COUNT: ${parsed.products.length}");
        return parsed;
      } else {
        debugPrint("🔴 API FAILED: ${response.statusCode}");
        return null;
      }
    } on SocketException {
      debugPrint("🔴 No Internet connection");
      return null;
    } catch (e) {
      debugPrint("🔴 ERROR: $e");
      return null;
    }
  }
}