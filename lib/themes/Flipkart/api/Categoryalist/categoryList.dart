
import 'package:dio/dio.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Flipkart/utility/app_constant.dart';


class FlipkartCategoryApiService {
  final Dio _dio = Dio();

  Future<FlipkartCategoryResponse?> fetchCategories(String vendorId) async {
    final url = "${FlipkartAppConstant.baseUrl}${FlipkartAppConstant.fetchCategories}$vendorId";
    print("📌 Fetching categories from: $url");

    try {
      final response = await _dio.get(url);

      // Extract the 'data' node
      final data = response.data["data"];
      print(response.data);
return FlipkartCategoryResponse.fromJson(response.data);


    } catch (e) {
      print("❌ Error fetching categories: $e");
      return null;
    }
  }
}
