import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/product/productController.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/BestSellerScreen/flipkartBestSeller.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/FlipkartProduct/flipkartNewArrival.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/flipkartBanners.dart';
import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryTabs extends StatefulWidget {
  const HomeCategoryTabs({super.key});

  @override
  State<HomeCategoryTabs> createState() => _HomeCategoryTabsState();
}

class _HomeCategoryTabsState extends State<HomeCategoryTabs>
    with SingleTickerProviderStateMixin {
  final api = FlipkartCategoryApiService();
  final vendorController = Get.find<FlipkartVendorController>();
  final ProductController productCtrl = Get.find<ProductController>();

  List categories = [];
  bool loading = true;
  int selectedIndex = 0;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // ✅ 1. Call immediately if vendorId already exists
    final id = vendorController.vendorId.value;
    if (id.isNotEmpty) {
      print("✅ VendorId already available: $id");
      _loadCategories();
    }

    // ✅ 2. Listen for future changes
    ever<String>(vendorController.vendorId, (id) {
      if (id.isNotEmpty) {
        print("🔁 VendorId updated: $id");
        _loadCategories();
      }
    });
  }

  Future<void> _loadCategories() async {
    final vendorId = vendorController.vendorId.value;
    if (vendorId.isEmpty) return;

    setState(() => loading = true);

    final res = await api.fetchCategories(vendorId);
    categories = res?.data?.categories ?? [];

    if (categories.isNotEmpty) {
      _tabController?.dispose(); // dispose old controller

      _tabController = TabController(
        length: categories.length,
        vsync: this,
      );

      // 🔥 LOAD FIRST CATEGORY BY DEFAULT
      productCtrl.loadProducts(
        vendorId: vendorId,
        search: categories.first.name.toString(),
      );

      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) return;

        setState(() {
          selectedIndex = _tabController!.index;
        });

        final selectedCategory = categories[_tabController!.index];
        productCtrl.loadProducts(
          vendorId: vendorId,
          search: selectedCategory.name.toString(),
        );
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(height: 50, color: Colors.white),
      );
    }

    if (categories.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 80, // 👈 keep this
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: EdgeInsets.zero,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerColor: Colors.transparent,
              indicatorColor: const Color(0xFF2874F0),
              indicatorWeight: 3,
              labelPadding: const EdgeInsets.symmetric(horizontal: 18),
              tabs: List.generate(categories.length, (index) {
                final c = categories[index];
                final bool isSelected = selectedIndex == index;

                return Tab(
                  height: 72,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🔹 ICON
                      IconTheme(
                        data: IconThemeData(
                          color: isSelected
                              ? const Color(0xFF212121)
                              : const Color(0xFF9E9E9E),
                          size: 26,
                        ),
                        child: c.imageUrl != null
                            ? Image.network(
                                c.imageUrl ?? '',
                                height: 26,
                                width: 26,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.category, size: 26);
                                },
                              )
                            : const Icon(Icons.category),
                      ),

                      const SizedBox(height: 6),

                      // 🔹 TEXT
                      Text(
                        c.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF212121)
                              : const Color(0xFF9E9E9E),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // 🔹 SMALL INDICATOR (LIKE IMAGE)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 4,
                        width: isSelected ? 24 : 0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF212121),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )),
        Container(
          height: 1,
          color: const Color(0xFFE0E0E0), // Flipkart light grey
        ),

        /// 🔥 TAB CONTENT
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: TabBarView(
            controller: _tabController,
            children: categories.map<Widget>((c) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FlipkartBannerScreen(),
                      ),
                    ),
                    Obx(() {
                      if (productCtrl.loading.value) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                            itemBuilder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (productCtrl.products.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: Text("No products found")),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: productCtrl.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 165, // ⭐ controls card height exactly
                        ),
                        itemBuilder: (_, index) {
                          final product = productCtrl.products[index].product;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductByIdScreen(
                                      productId: product!.id.toString()),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xffF3F6FB),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Image.network(
    (product?.images != null && product!.images!.isNotEmpty)
        ? product.images!.first.image
        : (product?.product_image ?? ''),

    height: 95,
    width: double.infinity,
    fit: BoxFit.cover,

    // While loading
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return SizedBox(
        height: 95,
        child: Center(child: CircularProgressIndicator()),
      );
    },

    // If image fails
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 95,
        color: Colors.grey[200],
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 40,
        ),
      );
    },
  ),
),
                                  const SizedBox(height: 6),
                                  Text(
                                    product?.productName ??
                                        product?.title ??
                                        '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    NewArrivalSection(),
                    const SizedBox(height: 20),
                    BestSellerScreen(),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}
