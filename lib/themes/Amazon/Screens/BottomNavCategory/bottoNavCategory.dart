import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/product/productController.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Amz-Sub-Category/Amz-sub-Category.dart';
import 'package:one_click_builder/themes/Amazon/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart';

import '../../Modules/Amz-Sub-Category/Amz-sub-Category.dart';
import '../Home/AmzProductById/productById.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final AmzCategoryApiService apiService = AmzCategoryApiService();
  AmzCategoryResponse? categoryResponse;
  bool loading = true;

  final CategoryUIController categoryCtrl = Get.find<CategoryUIController>();
  final AmzVendorController vendorController =
  Get.find<AmzVendorController>();
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
        if (id.isNotEmpty) loadCategories(id);
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
        categoryCtrl.select(0);
        productCtrl.loadProducts(
          vendorId: vendorId,
          search: res!.data!.categories!.first.name!,
        );
      }
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _vendorWorker.dispose();
    super.dispose();
  }

  // =========================================================
  // UI
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F3F3),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Row(
        children: [
          _leftCategoryList(),
          Expanded(child: _rightProductGrid()),
        ],
      ),
    );
  }

  // =========================================================
  // LEFT CATEGORY (Amazon Exact Feel)
  // =========================================================
  Widget _leftCategoryList() {
    final categories = categoryResponse?.data?.categories ?? [];

    return Container(
      width: 95,
      color: const Color(0xffEFEFEF),
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
                  search: cat.name!,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(
                      color:
                      isSelected ? const Color(0xff008296) : Colors.transparent,
                      width: 4,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 42,
                      width: 42,
                      child: Image.network(
                        cat.imageUrl ?? "",
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.category, size: 22),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.name ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xff008296)
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // =========================================================
  // RIGHT PRODUCT GRID (same as before – clean)
  // =========================================================
  Widget _rightProductGrid() {
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      if (productCtrl.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (productCtrl.products.isEmpty) {
        return const Center(child: Text("No products found"));
      }

      return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: productCtrl.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: width < 360 ? 0.45 : 0.55,
          ),
          itemBuilder: (context, index) =>
              _buildProductCard(context, productCtrl.products[index]),
        ),
      );
    });
  }

  // =========================================================
  // PRODUCT CARD (Amazon Like)
  // =========================================================
  Widget _buildProductCard(BuildContext context, ProductData item) {
    final product = item.product;

    final title = product?.title ?? "No Title";
    final imageUrl = product?.images?.isNotEmpty == true
        ? product!.images!.first.image ?? ""
        : "";

    double sellingPrice = double.tryParse(
      product?.images?.first.sizes?.first.price ?? "0",
    ) ??
        0;

    double mrp = (product?.discountPrice ?? 0).toDouble();

    int discount =
    (mrp > sellingPrice && mrp > 0)
        ? (((mrp - sellingPrice) / mrp) * 100).round()
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AmzProductByIdScreen(productId: product!.id.toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: _productImage(imageUrl),
              ),
            ),
            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              child: Text(
                "₹$sellingPrice",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (discount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                child: Text(
                  "M.R.P ₹$mrp ($discount% off)",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            // const Spacer(),
            // const Padding(
            //   padding: EdgeInsets.all(8),
            //   child: Text(
            //     "FREE delivery Tomorrow",
            //     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget _productImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return _imagePlaceholder();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xffF5F5F5),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }

}

