import 'package:dio/dio.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Nexus-Sub-Category/Flipkart-sub-Category.dart';
import 'package:one_click_builder/themes/Flipkart/utility/app_constant.dart';

class ProductApiService {
  final Dio _dio = Dio();
Future<List<ProductData>> fetchProducts({
  required String categoryId,
  String search = "",
}) async {
  final url =
      "${FlipkartAppConstant.baseUrl}${FlipkartAppConstant.product_list}$categoryId";

  try {
    final response = await _dio.get(
      url,
      queryParameters: {
        if (search.trim().isNotEmpty) "search": search.trim(),
        "page": 1,
        "limit": 50,
      },
    );

    print("🚀 FINAL URL: ${response.requestOptions.uri}");
    print("📥 RAW RESPONSE: ${response.data}");

    if (response.statusCode == 200 && response.data is Map) {
      final data = response.data["data"];

      final List list =
          data is Map && data["product"] is List
              ? data["product"]
              : [];

      final products =
          list.map((e) => ProductData.fromJson(e)).toList();

      print("📦 Total products: ${products.length}");

      return products;
    }

    return [];
  } catch (e, stack) {
    print("❌ Error fetching products: $e");
    print("🔍 STACK: $stack");
    return [];
  }
}


}
