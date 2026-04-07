import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/FlipkartProducts/FlipkartProduct.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/FlipkartProduct/flipkartProductCard.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/FlipkartProduct/viewallProductr.dart';
import 'package:one_click_builder/themes/Flipkart/api/FlipkartProduct/nexusProduct.dart';
import 'package:shimmer/shimmer.dart';

class NewArrivalSection extends StatefulWidget {
  const NewArrivalSection({super.key});

  @override
  State<NewArrivalSection> createState() => _NewArrivalSectionState();
}

class _NewArrivalSectionState extends State<NewArrivalSection> {
  ProductListResponse? response;
  bool loading = false;
  bool _apiRunning = false;

  final FlipkartVendorController vendorController =
      Get.find<FlipkartVendorController>();

  Worker? _vendorWorker;
  String? _lastVendorId;

  @override
  void initState() {
    super.initState();

    // Try loading immediately if vendorId already exists
    _tryLoad(vendorController.vendorId.value);

    // Listen ONLY when vendorId actually changes
    _vendorWorker = ever<String>(
      vendorController.vendorId,
      (vendorId) => _tryLoad(vendorId),
    );
  }

  void _tryLoad(String vendorId) {
    if (vendorId.isEmpty) return;
    if (vendorId == _lastVendorId) return;

    _lastVendorId = vendorId;
    _loadProducts(vendorId);
  }

  Future<void> _loadProducts(String vendorId) async {
    if (_apiRunning) return; // ✅ stop parallel calls
    _apiRunning = true;

    setState(() => loading = true);

    try {
final res = await ProductService().getProducts(
  vendorId,
  page: 1,
  limit: 30,
);

      if (!mounted) return;

      if (res != null && res.products.isNotEmpty) {
        setState(() => response = res);
      }
    } catch (e) {
      debugPrint("❌ Product API error: $e");
    } finally {
      if (mounted) setState(() => loading = false);
      _apiRunning = false;
    }
  }

  @override
  void dispose() {
    _vendorWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vendorId = vendorController.vendorId.value;

      // ⏳ Vendor not ready yet
      if (vendorId.isEmpty) {
        return SizedBox(
          height: 420,
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
        );
      }
       return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min, // 🔥 KEY LINE
  children: [
    _header(context),
    const SizedBox(height: 10),

    /// LOADING
    if (loading)
      SizedBox(
        height: 360, // shimmer needs some space
        child: _shimmerList(),
      )

    /// PRODUCTS
    else if ((response?.products.isNotEmpty ?? false))
     GridView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: response!.products.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 14,
    childAspectRatio: 0.67, // 🔥 KEY CHANGE
  ),
  itemBuilder: (context, index) {
    final product = response!.products[index].product;
    if (product == null) return const SizedBox.shrink();
    return Flipkartproductcard(product: product);
  },
)


    /// EMPTY STATE (NO HEIGHT WASTE)
    else
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("No products available")),
      ),
  ],
);

    });
  }

Widget _shimmerList() {
  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemCount: 6,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 14,
      childAspectRatio: 0.68,
    ),
    itemBuilder: (_, __) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Container(height: 12, width: 120, color: Colors.grey.shade300),
            const SizedBox(height: 6),
            Container(height: 14, width: 90, color: Colors.grey.shade300),
          ],
        ),
      );
    },
  );
}


 Widget _productList() {
  final items =
      response?.products.where((e) => e.product != null).toList() ?? [];

  if (items.isEmpty) {
    return const Center(child: Text("No products available"));
  }

  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    itemCount: items.length, // ✅ supports 20+ products
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,           // 🔥 TWO CARDS
      crossAxisSpacing: 12,
      mainAxisSpacing: 14,
      childAspectRatio: 0.68,      // 👈 Flipkart-like ratio
    ),
    itemBuilder: (context, index) {
      return Flipkartproductcard(
        product: items[index].product!,
      );
    },
  );
}


  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child:Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "New Arrivals",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    GestureDetector(
      onTap: () {
        final products = response?.products ?? [];
        if (products.isEmpty) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ViewAllProductsScreen(products: products),
          ),
        );
      },
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF2874F0), // Flipkart blue
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.white,
        ),
      ),
    ),
  ],
),

    );
  }
}
