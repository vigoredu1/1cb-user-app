// lib/services/sub_category_api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/model/sub_categery_responce.dart';
import '../utility/local_storage.dart';

class SubCategoryApiService {
  static const String baseUrl = 'https://api.1clickbuilder.com';
  static const String subCategoryEndpoint = '/api/category/sub-category';

  Future<SubCategoryResponse> fetchSubCategories() async {
    String? token = await StorageHelper.getToken();
    final url = Uri.parse("$baseUrl$subCategoryEndpoint");

    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "$token"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print("Sub_categery");
      print(responseData);
      return SubCategoryResponse.fromJson(responseData);
    } else {
      print("Error");
      throw Exception('Failed to load sub categories');
    }
  }
}
