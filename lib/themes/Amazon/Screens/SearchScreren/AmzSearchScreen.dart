import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Search/searchControllers.dart';
import 'package:shimmer/shimmer.dart';

import '../Home/AmzProductById/productById.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NexusSearchController ctrl = Get.find();

  @override
  void dispose() {
    ctrl.clearSearch(); // ✅ CLEAR WHEN SCREEN CLOSES
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AmzProductByIdScreen(productId: product['id']),
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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),

                    /// 📦 TITLE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        product['title'] ?? '',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "₹",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            displayPrice.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// 🚚 DELIVERY TEXT
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "FREE Delivery",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    //
                    // /// 🛒 BUY BUTTON
                    // Padding(
                    //   padding: const EdgeInsets.all(8),
                    //   child: SizedBox(
                    //     height: 36,
                    //     width: double.infinity,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: const Color(0xFFFFD814), // Amazon yellow
                    //         foregroundColor: Colors.black,
                    //         elevation: 0,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //       onPressed: () {
                    //         // buy logic here
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
          },
        );
      }),
    );
  }
}
