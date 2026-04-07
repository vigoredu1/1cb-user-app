import 'package:dio/dio.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Nexus-Sub-Category/Nexus-sub-Category.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';


// class ProductApiService {
//   final Dio _dio = Dio();

//   Future<List<ProductData>> fetchProducts({
//     required String categoryId,
//     String search = "",
//   }) async {
//     final url =
//         "${NexusAppConstant.baseUrl}/product/product-list/$categoryId";

//         print("from Subcategory ${url}");

//     try {
//       print("📌 Fetching products from: $url  PARAMS: search=$search");

//       final response = await _dio.get(
//         url,
//         queryParameters: {"search": search},
//       );

//       print("📥 RAW RESPONSE: ${response.data}");

//       if (response.statusCode == 200 &&
//           response.data is Map &&
//           response.data["data"] is List) {

//         /// Parse JSON
//         final jsonResponse = ProductResponse.fromJson(response.data);

//         /// Null-safe list
//         final List<ProductData> list = jsonResponse.data ?? [];

//         print("📦 Total products: ${list.length}");

//         return list;
//       }

//       return [];

//     } catch (e, stack) {
//       print("❌ Error fetching products: $e");
//       print("🔍 STACK: $stack");
//       return [];
//     }
//   }
// }



class ProductApiService {
  final Dio _dio = Dio();

  Future<List<ProductData>> fetchProducts({
    required String categoryId,
    String search = "",
  }) async {
    final url =
        "${NexusAppConstant.baseUrl}/api/product/product-list/$categoryId";

    print("from Subcategory $url");

    try {
      final response = await _dio.get(
        url,
        queryParameters: {"search": search},
      );

      print("FINAL URL 👉 ${response.requestOptions.uri}");
      print("📥 RAW RESPONSE: ${response.data}");

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data["data"] is List) {
        final jsonResponse = ProductResponse.fromJson(response.data);
        return jsonResponse.data ?? [];
      }

      return [];
    } catch (e, stack) {
      print("❌ Error fetching products: $e");
      print("🔍 STACK: $stack");
      return [];
    }
  }
}
