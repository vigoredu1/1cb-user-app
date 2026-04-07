import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Nexus-Sub-Category/Flipkart-sub-Category.dart';
import 'package:one_click_builder/themes/Flipkart/api/SubCategory/FlipkartGetSubCategory.dart';



class ProductController extends GetxController {
  final ProductApiService apiService = ProductApiService();

  RxBool loading = false.obs;
  RxList<ProductData> products = <ProductData>[].obs;

  Future<void> loadProducts({
    required String vendorId,
    required String search,
  }) async {
    loading.value = true;
    products.clear();

    final response = await apiService.fetchProducts(
      categoryId: vendorId, // ✅ vendorId (same as working screen)
      search: search,       // ✅ category/subcategory name
    );

    products.assignAll(response);
    loading.value = false;
  }
}
