import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../data/model/home/product_responce.dart';
import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class ProductApiService {
  Future<ProductResponse> fetchProductsWithoutCategory() async {
    final url = Uri.parse("${AppConstant.baseUrl}${AppConstant.product}");
    String? token = await StorageHelper.getToken();

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "$token"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return ProductResponse.fromJson(responseData);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
