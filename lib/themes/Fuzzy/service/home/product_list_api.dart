import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../data/model/product_list_model.dart';
import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class ProductListApiService {
  static const int timeoutSeconds = 30;

  static Future<List<ProductList>> fetchProducts() async {
    try {
      final vendorId = await StorageHelper.getVendorId();
      final url = Uri.parse(
          "${AppConstant.baseUrl}${AppConstant.product_list}$vendorId");

      final response =
          await http.get(url).timeout(const Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['data'] is List) {
          return (responseData['data'] as List)
              .map((item) => ProductList.fromJson(item))
              .toList();
        } else {
          throw const FormatException('Invalid data format from API');
        }
      } else {
        throw HttpException(
            'API request failed with status: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      debugPrint('JSON parsing error: $e');
      rethrow;
    } on http.ClientException catch (e) {
      debugPrint('Network error: $e');
      rethrow;
    }
  }
}
