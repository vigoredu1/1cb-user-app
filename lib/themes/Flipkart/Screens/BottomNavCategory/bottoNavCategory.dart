import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/cart_controller.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/product/productController.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Nexus-Sub-Category/Flipkart-sub-Category.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Cart/flipkartCart.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';
import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';
import 'package:one_click_builder/themes/Flipkart/utility/plugin_list.dart';

import 'package:shimmer/shimmer.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final FlipkartCategoryApiService apiService = FlipkartCategoryApiService();

  FlipkartCategoryResponse? categoryResponse;
  bool loading = true;
  String searchKeyword = ""; // ✅ NEW

  final FlipkartCategoryUIController categoryCtrl =
      Get.find<FlipkartCategoryUIController>();

  final FlipkartVendorController vendorController =
      Get.find<FlipkartVendorController>();

  final ProductController productCtrl = Get.put(ProductController());
  bool isSearchResult = false;

  late Worker _vendorWorker;
  bool isSearching = false;
  final TextEditingController searchTextCtrl = TextEditingController();
  final CartController cartController = Get.find<CartController>();
  final GuestCartController guestCartController =
      Get.find<GuestCartController>();

  @override
  void initState() {
    super.initState();

    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      loadCategories(vendorId);
    }

    _vendorWorker = ever<String>(
      vendorController.vendorId,
      (id) {
        if (id.isNotEmpty) {
          loadCategories(id);
        }
      },
    );
  }

  Future<void> loadCategories(String vendorId) async {
    setState(() => loading = true);

    try {
      final res = await apiService.fetchCategories(vendorId);

      if (!mounted) return;

      setState(() {
        categoryResponse = res;
        loading = false;
      });

      if (res?.data?.categories?.isNotEmpty == true) {
        final first = res!.data!.categories!.first;
        categoryCtrl.select(0);

        productCtrl.loadProducts(
          vendorId: vendorId,
          search: first.name.toString(),
        );
      }
    } catch (e) {
      debugPrint("❌ Category load error: $e");
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _vendorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false, // ✅ important
        titleSpacing: 16,

        /// ⬅️ LEFT TITLE
        title: isSearching
            ? _searchBar()
            : isSearchResult
                ? Text(
                    'Results for "$searchKeyword"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  )
                : const Text(
                    "All Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

        /// ➡️ RIGHT ICONS
        actions: [
          /// 🔍 SEARCH ICON
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  isSearchResult = false;
                  searchKeyword = "";
                  searchTextCtrl.clear();

                  final index = categoryCtrl.selectedIndex.value;
                  final categories = categoryResponse?.data?.categories ?? [];
                  if (categories.isNotEmpty && index < categories.length) {
                    productCtrl.loadProducts(
                      vendorId: vendorController.vendorId.value,
                      search: categories[index].name.toString(),
                    );
                  }
                } else {
                  isSearching = true;
                }
              });
            },
          ),

          /// 🛒 CART ICON WITH COUNT
          Obx(() {
            final prefs = Get.find<SharedPreferences>();
            final token = prefs.getString("token");

            final count = token != null
                ? cartController.cartCount.value
                : guestCartController.guestCartCount.value;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => Get.to(() => const FlipkartCartScreen()),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 26,
                    ),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),

      body: loading
          ? _shimmerLoader()
          : isSearchResult

              /// 🔍 SEARCH RESULT VIEW (NO CATEGORY)
              ? _rightCategoryGrid()

              /// 📂 CATEGORY VIEW
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: [
                        _leftCategoryList(),
                        SizedBox(
                          width: constraints.maxWidth - 95,
                          child: _rightCategoryGrid(),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _searchBar() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF3FA9F5), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22, color: Color(0xFF6B6B6B)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchTextCtrl,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isEmpty) return;

                searchKeyword = value; // ✅ SAVE KEYWORD

                productCtrl.loadProducts(
                  vendorId: vendorController.vendorId.value,
                  search: value,
                );

                setState(() {
                  isSearching = false;
                  isSearchResult = true;
                });

                searchTextCtrl.clear();
              },
              decoration: const InputDecoration(
                hintText: "Search products",
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------
  // LEFT CATEGORY LIST
  // -------------------------------------------------
  Widget _leftCategoryList() {
    final categories = categoryResponse?.data?.categories ?? [];

    return Container(
      width: 95,
      color: Colors.white,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];

          return Obx(() {
            final isSelected = categoryCtrl.selectedIndex.value == index;

            return InkWell(
              onTap: () {
                setState(() {
                  isSearchResult = false; // ✅ RESTORE CATEGORY VIEW
                });
                categoryCtrl.select(index);
                productCtrl.loadProducts(
                  vendorId: vendorController.vendorId.value,
                  search: cat.name.toString(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xffF1F5FF),
                  border: Border(
                    left: BorderSide(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.network(
                        cat.imageUrl ?? "",
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.category),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // -------------------------------------------------
  // RIGHT CATEGORY GRID (MATCHES IMAGE)
  // -------------------------------------------------
  Widget _rightCategoryGrid() {
    return Obx(() {
      if (productCtrl.loading.value) {
        return _shimmerLoader();
      }

      if (productCtrl.products.isEmpty) {
        return const Center(child: Text("No items found"));
      }

      return Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: productCtrl.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 6,
            childAspectRatio: 0.67,
          ),
          itemBuilder: (context, index) {
            return _buildCategoryTile(
              context,
              productCtrl.products[index],
            );
          },
        ),
      );
    });
  }

  // -------------------------------------------------
  // CATEGORY TILE (EXACT UI MATCH)
  // -------------------------------------------------
  Widget _buildCategoryTile(BuildContext context, ProductData item) {
    final product = item.product;

    final String title =
        product?.title?.isNotEmpty == true ? product!.title! : "";

    final String imageUrl = product?.images?.isNotEmpty == true
        ? product!.images!.first.image ?? ""
        : "";

    return GestureDetector(
      onTap: () {
        if (product?.id == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductByIdScreen(productId: product!.id.toString()),
          ),
        );
      },
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F6FF), // light bluish bg
              borderRadius: BorderRadius.circular(22),
            ),
            alignment: Alignment.center,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 60,
                    width: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image, color: Colors.grey),
                  )
                : const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          SizedBox(
            //width: 96,
            child: Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------
  // SHIMMER
  // -------------------------------------------------
  Widget _shimmerLoader() {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 120,
          height: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
