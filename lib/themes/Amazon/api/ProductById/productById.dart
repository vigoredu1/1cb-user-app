import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Amazon/Modules/ProductById/AmzProductById.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';

class AmzProductById {
  // Remove apiUrl from here, we will create it dynamically inside method

  Future<Product?> fetchProduct(String productId) async {
    // Dynamically create API URL with the productId
    final String apiUrl = '${AmzAppConstant.baseUrl}${AmzAppConstant.productetail}$productId';

    print( "  byiiiddd  ${apiUrl}");

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final productResponse = ProductResponse.fromJson(jsonData);
      return productResponse.data?.product;
    } else {
      throw Exception('Failed to load product');
    }
  }
}
