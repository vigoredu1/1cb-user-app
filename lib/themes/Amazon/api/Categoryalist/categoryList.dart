
import 'package:dio/dio.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';


class AmzCategoryApiService {
  final Dio _dio = Dio();

  Future<AmzCategoryResponse?> fetchCategories(String vendorId) async {
    final url = "${AmzAppConstant.baseUrl}${AmzAppConstant.fetchCategories}$vendorId";
    print("📌 Fetching categories from: $url");

    try {
      final response = await _dio.get(url);

      // Extract the 'data' node
      final data = response.data["data"];
      print(response.data);
return AmzCategoryResponse.fromJson(response.data);


    } catch (e) {
      print("❌ Error fetching categories: $e");
      return null;
    }
  }
}
