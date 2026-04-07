import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/Modules/FlipkartProducts/FlipkartProduct.dart';
import 'package:one_click_builder/themes/Flipkart/utility/app_constant.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ProductService {
  Future<ProductListResponse?> getProducts(
    String vendorId, {
    required int page,
    required int limit,
  }) async {
    final url =
        "${FlipkartAppConstant.baseUrl}${FlipkartAppConstant.product_list}$vendorId"
        "?page=$page&limit=$limit";

    debugPrint("🟡 Product API URL: $url");

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      debugPrint("🟢 STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final parsed = productListResponseFromJson(response.body);
        debugPrint("🟢 PARSED PRODUCTS COUNT: ${parsed.products.length}");
        return parsed;
      }

      debugPrint("🔴 API FAILED: ${response.statusCode}");
      return null;
    } on TimeoutException {
      debugPrint("⏱ Product API timeout");
      return null;
    } catch (e) {
      debugPrint("🔴 Product API error: $e");
      return null;
    }
  }
}
