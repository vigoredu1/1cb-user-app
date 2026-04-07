import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/homepage/product_list_provider.dart';
import 'product_list_screen.dart';

class ExploreCollectionWidget extends StatelessWidget {
  const ExploreCollectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListController>(
      builder: (_, controller, __) {
        if (controller.isLoading) {
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


        if (controller.products.isEmpty) {
          return const Center(
            child: Text(
              "",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }


        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: Text(
                    "Explore Collections",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  )),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {

                  final product = controller.products[index];

// Safe image getter
                  final imageUrl = (product.images.isNotEmpty)
                      ? product.images.first.image
                      : "";   // fallback

                  print(imageUrl);
print('hgyfdsasdfgy');
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListScreen(
                            product: product,
                            title: "",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            spreadRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Image.network(
                              '${product.images.first.image}',
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  product.categoryName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        );
      },
    );
  }
}
