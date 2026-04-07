
import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../Modules/Banners/banner.dart';
import '../../utility/app_constant.dart';



class AmzBannerApiService {
  // Use the real base URL used in your project
  static const String baseUrl =
      "${AmzAppConstant.baseUrl}/banner/banner-list/";

  /// Instance method that your UI expects to call:
  /// await apiService.getBannerList(vendorId)
  Future<BannerListResponse?> getBannerList(String vendorId) async {
    final uri = Uri.parse("${AmzAppConstant.baseUrl}${AmzAppConstant.bannerUrl}$vendorId");


    print("bannerssss${uri} "              );

    try {
      // Helpful logs for debugging
      print("▶️ Fetching banners from: $uri");

      final response = await http.get(uri);

      print("◀️ Status: ${response.statusCode}");
      // print("Body: ${response.body}"); // enable if needed

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        // Match your model: BannerListResponse.fromJson expects json with data->banners
        return BannerListResponse.fromJson(jsonData);
      } else {
        print("❌ getBannerList failed: ${response.statusCode}");
        return null;
      }
    } catch (e, st) {
      print("🔥 Exception in getBannerList: $e\n$st");
      return null;
    }
  }
}
