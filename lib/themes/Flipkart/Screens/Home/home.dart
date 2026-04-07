import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/product/productController.dart';
import 'package:one_click_builder/themes/Flipkart/Main/main.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/HomeCategoryTab.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/SearchScreren/NexusSearchScreen.dart';
import 'package:one_click_builder/themes/Flipkart/api/BestSeller/NexusBestSeller.dart';
import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';
import 'package:one_click_builder/themes/Flipkart/api/FlipkartProduct/nexusProduct.dart';
import 'package:one_click_builder/themes/Flipkart/api/banners/bannersApi.dart';

class FlipkartHome extends StatefulWidget {
  const FlipkartHome({super.key});

  @override
  State<FlipkartHome> createState() => _FlipkartHomeState();
}

class _FlipkartHomeState extends State<FlipkartHome> {
  final bannerApi = NexusBannerApiService();
  final categoryApi = FlipkartCategoryApiService();
  final newApi = ProductService();
  final bestApi = BestSellerService();

  final TextEditingController searchTextCtrl = TextEditingController();

  late FlipkartVendorController vendorCtrl;
  late FlipkartSearchController searchCtrl;

  int _selectedIndex = 0;

  late ProductController productCtrl;

  Future<void> _refreshHome() async {
    final vendorId = vendorCtrl.vendorId.value;

    if (vendorId.isEmpty) return;

    await Future.wait([
      bannerApi.getBannerList(vendorId),
      categoryApi.fetchCategories(vendorId),
      bestApi.getBestSellerProducts(vendorId),
      productCtrl.loadProducts(
        vendorId: vendorId,
        search: "",
      ),
    ]);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    vendorCtrl = Get.find<FlipkartVendorController>();
    searchCtrl = Get.find<FlipkartSearchController>();
    productCtrl = Get.find<ProductController>();

    vendorCtrl.loadVendorFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            /// 🏪 Vendor Logo
            GestureDetector(
              onTap: () async {
                await _refreshHome(); // 🔥 refresh only home
              },
              child: SizedBox(
                height: 70,
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/brand_logo.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 5),

            /// 🔍 Flipkart-style Search Bar (your UI – unchanged)
            Expanded(
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4FAFF),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFF3FA9F5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 22, color: Color(0xFF6B6B6B)),
                    const SizedBox(width: 8),

                    Expanded(
                      child: TextField(
                        controller: searchTextCtrl,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) async {
                          if (value.trim().isEmpty) return;

                          searchCtrl.searchProduct(value);
                          await Get.to(() => const SearchScreen());
                          searchTextCtrl.clear();
                        },
                        decoration: const InputDecoration(
                          hintText: "",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: () {
                    //     // future image search
                    //   },
                    //   child: const Icon(
                    //     Icons.camera_alt_outlined,
                    //     size: 22,
                    //     color: Color(0xFF6B6B6B),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),
              HomeCategoryTabs(key: UniqueKey()),
            ],
          ),
        ),
      ),
    );
  }
}
