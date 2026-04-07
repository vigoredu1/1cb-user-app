
import 'package:dio/dio.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';


class NexusCategoryApiService {
  final Dio _dio = Dio();

  Future<NexusCategoryResponse?> fetchCategories(String vendorId) async {
    final url = "${NexusAppConstant.baseUrl}${NexusAppConstant.fetchCategories}$vendorId";
    print("📌 Fetching categories from: $url");

    try {
      final response = await _dio.get(url);

      // Extract the 'data' node
      final data = response.data["data"];
      print(response.data);
return NexusCategoryResponse.fromJson(response.data);


    } catch (e) {
      print("❌ Error fetching categories: $e");
      return null;
    }
  }
}
