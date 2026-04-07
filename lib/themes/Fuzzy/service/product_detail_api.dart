import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/model/product_detail_service.dart';
import '../utility/app_constant.dart';
import '../utility/local_storage.dart'; // Assumes StorageHelper is defined here

class ProductDetailApiService {
  Future<ProductDetailResponse> fetchProductDetail(String productId) async {
    // Assuming the API URL needs the productId as a query parameter
    final url = Uri.parse(
        "${AppConstant.baseUrl}${AppConstant.productetail}/$productId");

    // Retrieve token from local storage for authentication.
    String? token = await StorageHelper.getToken();
    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return ProductDetailResponse.fromJson(responseData);
    } else {
      throw Exception("Failed to load product detail: ${response.statusCode}");
    }
  }
}
