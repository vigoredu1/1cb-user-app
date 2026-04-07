import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Amz-Sub-Category/Amz-sub-Category.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../api/SubCategory/AmzGetSubCategory.dart';
import '../../AmzProductById/productById.dart';

class AllSubCategory extends StatefulWidget {
  final String subcategoryId;
  final String subcategoryName;

  const AllSubCategory({
    super.key,
    required this.subcategoryId,
    required this.subcategoryName,
  });

  @override
  State<AllSubCategory> createState() => _AllSubCategoryState();
}

class _AllSubCategoryState extends State<AllSubCategory> {
  bool loading = true;
  List<ProductData> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
  }

  Future<void> fetchProducts() async {
    final api = ProductApiService();
    final vendorId = Get.find<AmzVendorController>().vendorId.value;

    final response = await api.fetchProducts(
      categoryId: vendorId,
      search: widget.subcategoryName,
    );

    setState(() {
      products = response;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.subcategoryName)),
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
          : Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      //  mainAxisExtent: 390,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: width < 360 ? 0.52 : 0.60,
                    ),
                    itemBuilder: (context, i) => _buildProductCard(products[i]),
                  ),
                ),
              ],
            ),
    );
  }

  // ------------------------------------------------------------
  // FIXED PRODUCT CARD → FULL NULL SAFETY
  // ------------------------------------------------------------
  Widget _buildProductCard(ProductData item) {
    final product = item.product!;
    final String title = product.title ?? "No Title";

    // IMAGE
    final String imageUrl =
    product.images != null &&
        product.images!.isNotEmpty &&
        product.images!.first.image != null
        ? product.images!.first.image!
        : "";

    // PRICE (IMAGE → SIZE → FALLBACK)
    double rawPrice = 0;

    if (product.images != null &&
        product.images!.isNotEmpty &&
        product.images!.first.sizes != null &&
        product.images!.first.sizes!.isNotEmpty &&
        product.images!.first.sizes!.first.price != null) {
      rawPrice = double.tryParse(
          product.images!.first.sizes!.first.price.toString()) ??
          0;
    } else {
      rawPrice = (product.price ?? 0).toDouble();
    }

    final int displayPrice = rawPrice.round();
    final int mrp = product.mrpPrice ?? displayPrice;
    final int discount =
    mrp > displayPrice ? (((mrp - displayPrice) / mrp) * 100).round() : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AmzProductByIdScreen(productId: product.id.toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼 IMAGE
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Center(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    /// 🔥 DISCOUNT BADGE
                    if (discount > 0)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "-$discount%",
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
            ),

            /// 📦 TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 6),

            /// 💰 PRICE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Text("₹", style: TextStyle(fontSize: 12)),
                  Text(
                    displayPrice.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (mrp > displayPrice)
                    Text(
                      "₹$mrp",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),

            /// 🚚 DELIVERY
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                "FREE Delivery",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),

            /// 🛒 BUY BUTTON
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: SizedBox(
            //     height: 36,
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFFFFD814),
            //         foregroundColor: Colors.black,
            //         elevation: 0,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //       onPressed: () {
            //         // BUY NOW ACTION
            //       },
            //       child: const Text(
            //         "Buy Now",
            //         style: TextStyle(
            //           fontSize: 13,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
