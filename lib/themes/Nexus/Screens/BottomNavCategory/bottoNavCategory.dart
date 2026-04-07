import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/product/productController.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Nexus-Sub-Category/Nexus-sub-Category.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';
import 'package:one_click_builder/themes/Nexus/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final NexusCategoryApiService apiService = NexusCategoryApiService();

  NexusCategoryResponse? categoryResponse;
  bool loading = true;

  final CategoryUIController categoryCtrl = Get.find<CategoryUIController>();

  final NexusVendorController vendorController =
      Get.find<NexusVendorController>();

  final ProductController productCtrl = Get.put(ProductController());

  late Worker _vendorWorker;

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

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
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

      /// ✅ AUTO LOAD FIRST CATEGORY PRODUCTS
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
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        title: const Text("All Categories"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    _leftCategoryList(),
                    SizedBox(
                      width: constraints.maxWidth - 95,
                      child: _rightProductGrid(),
                    ),
                  ],
                );
              },
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
                categoryCtrl.select(index);

                productCtrl.loadProducts(
                  vendorId: vendorController.vendorId.value,
                  search: cat.name.toString(),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xffF1F5FF) : Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  //   crossAxisAlignment: ,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // optional: remove if you want sharp edges
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.network(
                          cat.imageUrl ?? "",
                          fit: BoxFit.cover, // 🔥 important
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.category),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // shows ...
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

  // // -------------------------------------------------
  // // RIGHT PRODUCT GRID
  // // -------------------------------------------------
  Widget _rightProductGrid() {
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      if (productCtrl.loading.value) {
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

      if (productCtrl.products.isEmpty) {
        return const Center(child: Text("No products found"));
      }

      return Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: productCtrl.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 12,
            childAspectRatio: width < 360 ? 0.39 : 0.45,
          ),
          itemBuilder: (context, index) {
            return _buildProductCard(
              context,
              productCtrl.products[index],
            );
          },
        ),
      );
    });
  }

  Widget _buildProductCard(BuildContext context, ProductData item) {
    final product = item.product;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    SizedBox(
      height: (screenHeight * 0.055).clamp(30.0, 52.0),
    );

    final String title =
        product?.title?.isNotEmpty == true ? product!.title! : "No Title";

    final String imageUrl = product?.images?.isNotEmpty == true
        ? product!.images!.first.image ?? ""
        : "";

    // -------------------------------
// 1️⃣ SELLING PRICE FROM images[0].sizes[0].price
    double sellingPrice = 0;

    if (product?.images != null &&
        product!.images!.isNotEmpty &&
        product.images!.first.sizes != null &&
        product.images!.first.sizes!.isNotEmpty) {
      sellingPrice = double.tryParse(
            product.images!.first.sizes!.first.price ?? "0",
          ) ??
          0.0;
    }

// 2️⃣ MRP / CUT PRICE FROM API discountPrice
    double mrp = (product!.discountPrice ?? 0).toDouble();

// 3️⃣ DISCOUNT PERCENT
    int discountPercent = 0;

    if (mrp > sellingPrice && mrp > 0) {
      discountPercent = (((mrp - sellingPrice) / mrp) * 100).round();
    }

    return GestureDetector(
      onTap: () {
        if (product.id == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProductByIdScreen(productId: product.id.toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE (ratio based → mobile safe)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: AspectRatio(
                aspectRatio: 1 / 1.15, // controls height
                child: Container(
                  color: Colors.grey.shade200,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child:
                                Icon(Icons.image, size: 40, color: Colors.grey),
                          ),
                        )
                      : const Center(
                          child:
                              Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                ),
              ),
            ),

            /// TITLE
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),

            /// PRICE ROW (Wrap = no overflow)
            /// PRICE SECTION (FIXED – NO WRAP)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// SELLING PRICE
                  ///
                  Text(
                    "₹$sellingPrice",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// MRP + DISCOUNT
                  ///
                  if (discountPercent > 0)
                    Row(
                      children: [
                        Text(
                          "₹$mrp",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (discountPercent > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_downward,
                                size: 12,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "$discountPercent%",
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 10),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),

            /// BUY BUTTON (fixed height)
            const Spacer(),

            /// ✅ BUY BUTTON (guaranteed visible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: (screenWidth * 0.11).clamp(34.0, 40.0),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC1E3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (product.id == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductByIdScreen(
                            productId: product.id.toString()),
                      ),
                    );
                  },
                  child: Center(
                    child: const Text(
                      "BUY NOW",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
