import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';

import 'package:shimmer/shimmer.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FlipkartSearchController ctrl = Get.find();

  @override
  void dispose() {
    ctrl.clearSearch(); // ✅ CLEAR WHEN SCREEN CLOSES
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Results for "${ctrl.keyword.value}"',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
        }

        if (ctrl.products.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: ctrl.products.length,
          itemBuilder: (_, i) {
            final item = ctrl.products[i];
            




            /// ✅ ACTUAL API STRUCTURE
            final product = item['product'];

            final images = product['images'] as List? ?? [];

double displayPrice = 0;

if (images.isNotEmpty) {
  final sizes = images.first['sizes'] as List? ?? [];

  if (sizes.isNotEmpty) {
    final rawPrice = sizes.first['price'];

    if (rawPrice is num) {
      displayPrice = rawPrice.toDouble();
    } else if (rawPrice is String) {
      displayPrice = double.tryParse(rawPrice) ?? 0;
    }
  }
}



         //   final images = product['images'] as List? ?? [];

            final imageUrl = images.isNotEmpty ? images.first['image'] : '';

            return GestureDetector(   onTap: () {
              Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductByIdScreen(productId: product['id']),
          ),
        );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black.withOpacity(.08),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        product['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '₹ $displayPrice',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                 //   const SizedBox(height: 2),
                    // 🛒 BUTTON (STABLE)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: 38,
                        width: double.infinity,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xfff3c0e6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "BUY NOW",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
