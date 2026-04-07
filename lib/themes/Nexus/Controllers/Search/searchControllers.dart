import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';



class NexusSearchController extends GetxController {
  final isLoading = false.obs;
  final products = <dynamic>[].obs;
  final keyword = ''.obs;
void clearSearch() {
  products.clear();
  keyword.value = '';
  isLoading.value = false;
}

  final vendorCtrl = Get.find<NexusVendorController>();

  Future<void> searchProduct(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    keyword.value = query;
    isLoading.value = true;

    final url =
        '${NexusAppConstant.baseUrl}/api/product/product-list/'
        '${vendorCtrl.vendorId.value}'
        '?page=1&limit=10&title=$query';

    print('🔍 SEARCH URL → $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// ✅ CORRECT PARSING
        final List productList = data['data']?['product'] ?? [];

        products.assignAll(productList);

        print('✅ PRODUCTS FOUND: ${products.length}');
      } else {
        products.clear();
      }
    } catch (e) {
      print('❌ SEARCH ERROR: $e');
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
