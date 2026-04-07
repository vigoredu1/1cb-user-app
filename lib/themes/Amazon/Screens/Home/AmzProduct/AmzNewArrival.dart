import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Modules/AmzProducts/AmzProduct.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/AmzProduct/AmzProductCard.dart';
import 'package:one_click_builder/themes/Amazon/api/AmzProduct/AmzProduct.dart';


class NewArrivalSection extends StatefulWidget {
  const NewArrivalSection({super.key});

  @override
  State<NewArrivalSection> createState() => _NewArrivalSectionState();
}

class _NewArrivalSectionState extends State<NewArrivalSection> {
  ProductListResponse? response;
  int limit = 20;
  int page = 1;
  bool loading = false;
  bool _apiRunning = false;

  final AmzVendorController vendorController =
  Get.find<AmzVendorController>();

  Worker? _vendorWorker;
  String? _lastVendorId;

  @override
  void initState() {
    super.initState();

    _tryLoad(vendorController.vendorId.value);

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
  if (_apiRunning) return;
  _apiRunning = true;

  setState(() => loading = true);

  try {
    final res = await ProductService().getProducts(
      vendorId,
      page: page,
      limit: 20,
    );

    if (!mounted) return;

    if (res != null && res.products.isNotEmpty) {
      setState(() {
        if (response == null) {
          response = res; // first load
        } else {
          response!.products.addAll(res.products); // 🔥 append products
        }
      });
    }
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
   final items = response?.products
    .where((e) => e.product != null)
    .toList() ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            "Discover products for you",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),

        if (loading)
          _shimmerGrid()
        else if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No products available"),
          )
        else
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: items.length,
            shrinkWrap: true, // ✅ IMPORTANT
            physics: const NeverScrollableScrollPhysics(), // ✅ IMPORTANT
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // ✅ 2 products per row
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              return AmzProductCard(
                product: items[index].product!,
              );
            },
          ),
           const SizedBox(height: 16),

   Center(
  child: ElevatedButton(
    onPressed: () {
      page++;
      _loadProducts(vendorController.vendorId.value);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 6,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      shadowColor: Colors.black26,
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Load More",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(width: 8),
        Icon(Icons.expand_more, size: 18),
      ],
    ),
  ),
),
      ],
    );
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(14),
          ),
        );
      },
    );
  }
}


