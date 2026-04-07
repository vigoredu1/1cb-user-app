import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Modules/BestSellers/bestSellers.dart';

import '../AmzProductById/productById.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.product,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final String firstSizePrice =
    product.images.isNotEmpty &&
        product.images.first.sizes.isNotEmpty
        ? product.images.first.sizes.first.price
        : product.salePrice.toString();

    final double sellingPrice = double.tryParse(firstSizePrice) ?? 0;
    final double originalPrice = product.price ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AmzProductByIdScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // 🔴 DEAL TAG
            // Container(
            //   padding:
            //   const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.red),
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   child: const Text(
            //     "Deal",
            //     style: TextStyle(
            //       fontSize: 11,
            //       color: Colors.red,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),

            const SizedBox(height: 6),

            // 🖼 IMAGE + ADD BUTTON
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: imageUrl.isEmpty
                        ? Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_outlined,
                          size: 40, color: Colors.grey),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ➕ ADD BUTTON (Amazon style)
                  // Positioned(
                  //   bottom: 4,
                  //   right: 4,
                  //   child: CircleAvatar(
                  //     radius: 16,
                  //     backgroundColor: Colors.amber,
                  //     child: const Icon(Icons.add, size: 18),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // 📝 TITLE
            Text(
              (product.title ?? ""),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            // 💰 PRICE ROW
            Row(
              children: [
                Text(
                  "₹$firstSizePrice",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                if (originalPrice > sellingPrice)
                  Text(
                    "₹${originalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),

            // 🔥 DISCOUNT %
            if (originalPrice > sellingPrice)
              Text(
                "-${(((originalPrice - sellingPrice) / originalPrice) * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            //
            // const Text(
            //   "Limited time deal",
            //   style: TextStyle(
            //     fontSize: 11,
            //     color: Colors.red,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
