import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../data/model/home/category_responce.dart';
import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class ApiService {
  // Fetch categories with token check and store vendor id locally
  Future<CategoryResponse> fetchCategories() async {
    final url = Uri.parse("${AppConstant.baseUrl}${AppConstant.category}");
    String? token = await StorageHelper.getToken();

    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "$token"
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print("hello");
        // print(response.body);
        // Store vendor id from the first category item if available
        if (responseData['data'] != null &&
            (responseData['data'] as List).isNotEmpty) {
          var firstCategory = (responseData['data'] as List)[0];
          if (firstCategory['vendor_id'] != null) {
            await StorageHelper.saveVendorId(firstCategory['vendor_id']);
          }
        }
        return CategoryResponse.fromJson(responseData);
      } else {
        print(responseData['error']['message'] ?? "Login failed! Try again.");
        throw Exception(responseData['error']['message'] ?? "Login failed!");
      }
    } catch (e) {
      print("Something went wrong! Check your internet.");
      throw Exception("Something went wrong! Check your internet.");
    }

// <<<<<<< HEAD
// =======
//     // Ensure the function always returns or throws.
//     throw Exception("Unexpected error in fetchCategories");
// >>>>>>> origin/shubham
  }
}
