import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/Modules/BestSellers/bestSellers.dart';
import 'package:one_click_builder/themes/Flipkart/utility/app_constant.dart';

class BestSellerService {
  Future<BestSellerResponse?> getBestSellerProducts(String vendorId) async {
    try {
      final url =
          "${FlipkartAppConstant.baseUrl}${FlipkartAppConstant.bestSellingProduct}$vendorId";


          print("BestSeller $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return BestSellerResponse.fromJson(jsonDecode(response.body));
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("API Error: $e");
    }
    return null;
  }
}
