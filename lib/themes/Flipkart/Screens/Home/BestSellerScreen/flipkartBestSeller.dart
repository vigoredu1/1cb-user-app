import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/BestSellers/bestSellers.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/BestSellerScreen/nexusSellerCard.dart';
import 'package:one_click_builder/themes/Flipkart/api/BestSeller/NexusBestSeller.dart';

import 'package:shimmer/shimmer.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({super.key});

  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  BestSellerResponse? bestSellerResponse;
  bool loading = true;
  late Worker _vendorWorker;
  final FlipkartVendorController vendorController =
      Get.find<FlipkartVendorController>();

  @override
  void initState() {
    super.initState();

    debugPrint("INIT vendorId = ${vendorController.vendorId.value}");

    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      loadBestSellers(vendorId);
    }

    _vendorWorker = ever<String>(
      vendorController.vendorId,
      (vendorId) {
        debugPrint("VENDOR ID CHANGED => $vendorId");
        if (vendorId.isNotEmpty) {
          loadBestSellers(vendorId);
        }
      },
    );
  }

  Future<void> loadBestSellers(String vendorId) async {
    setState(() => loading = true);

    try {
      bestSellerResponse =
          await BestSellerService().getBestSellerProducts(vendorId);
    } catch (e) {
      debugPrint("BestSeller API error: $e");
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  @override
  void dispose() {
    _vendorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // ⭐ Hide entire section if no data and not loading
  if (!loading && (bestSellerResponse?.data.isEmpty ?? true)) {
    return const SizedBox.shrink();
  }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ⭐ Heading
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Best Selling Product",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

// ⭐ Content
        if (loading)
          Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 120,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        else
          (bestSellerResponse?.data.isEmpty ?? true)
              ? const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      "No Data Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: bestSellerResponse?.data.length ?? 0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,

                    // ⭐ Flipkart-style ratio
                    childAspectRatio: height < 360 ? 0.58 : 0.67,
                  ),
                  itemBuilder: (context, index) {
                    final product = bestSellerResponse?.data[index].product;
                    if (product == null) return const SizedBox();

                    final image = product.images.isNotEmpty
                        ? product.images.first.image ?? ""
                        : product.productImage ?? "";

                    return ProductCard(
                      product: product,
                      imageUrl: image,
                    );
                  },
                )
      ],
    );
  }
}
