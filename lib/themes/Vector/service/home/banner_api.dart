import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../data/model/home/banner_model.dart';
import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class BannerApiService {
  Future<List<BannerItem>> fetchBanners() async {
    final vendorId = await StorageHelper.getVendorId();
    final url =
        Uri.parse("${AppConstant.baseUrl}${AppConstant.bannerUrl}$vendorId");

    final response = await http.get(url);
    // print('API URL: $url');
    // print('Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print("Banner data");
      print(response.body);
      final List<dynamic> bannerJson = data['data']['banners'];

      // Parse only the banner list directly
      return bannerJson.map((e) => BannerItem.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load banners");
    }
  }
}
