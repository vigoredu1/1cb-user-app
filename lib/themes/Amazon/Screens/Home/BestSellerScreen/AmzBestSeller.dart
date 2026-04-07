import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Modules/BestSellers/bestSellers.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/BestSellerScreen/AmzSellerCard.dart';
import 'package:one_click_builder/themes/Amazon/api/BestSeller/AmzBestSeller.dart';
import 'package:shimmer/shimmer.dart';



class AmzBestSellerScreen extends StatefulWidget {
  const AmzBestSellerScreen({super.key});

  @override
  State<AmzBestSellerScreen> createState() => _AmzBestSellerScreenState();
}

class _AmzBestSellerScreenState extends State<AmzBestSellerScreen> {
  BestSellerResponse? bestSellerResponse;
  bool loading = true;
  late Worker _vendorWorker;
  final AmzVendorController vendorController =
      Get.find<AmzVendorController>();

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
      // ⭐ Hide entire section if not loading and data empty
  if (!loading && (bestSellerResponse?.data.isEmpty ?? true)) {
    return const SizedBox();
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
            child: Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),),
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
      : 
          GridView.builder(
            shrinkWrap: true, // 🔑 REQUIRED inside Column / ScrollView
            physics: const NeverScrollableScrollPhysics(), // 🔑
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: bestSellerResponse?.data?.length ?? 0,
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // ✅ TWO cards per row
              crossAxisSpacing: 11,
              mainAxisSpacing: 12,
            childAspectRatio: height < 360 ? 0.39 : 0.63,

            ),
            itemBuilder: (context, index) {
              final product = bestSellerResponse?.data?[index].product;
              if (product == null) return const SizedBox();

              final image = product.images!.isNotEmpty
                  ? product.images!.first.image ?? ""
                  : product.productImage ?? "";

              return ProductCard(
                product: product,
                imageUrl: image,
              );
            },
          ),
      ],
    );
  }
}
