import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/Modules/NexusProducts/NexusProduct.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';

class NexusProductCard extends StatelessWidget {
  final Product product;

  const NexusProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.images.isNotEmpty ? product.images.first.image : "";

    final String? firstSizePrice =
        product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
            ? product.images.first.sizes.first.price
            : null;
    double? discountPercent;

    if (firstSizePrice != null) {
      final original = double.tryParse(firstSizePrice);
      final discounted = product.discountPrice;

      if (original != null && original > discounted) {
        discountPercent = ((original - discounted) / original) * 100;
      }
    }

    final double? sellingPrice =
        firstSizePrice != null ? double.tryParse(firstSizePrice) : null;

    final double actualPrice = product.discountPrice;

    if (sellingPrice != null && actualPrice > sellingPrice) {
      discountPercent = ((actualPrice - sellingPrice) / actualPrice) * 100;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductByIdScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 IMAGE — takes remaining height safely
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: image.isEmpty
                    ? Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              size: 40, color: Colors.grey),
                        ),
                      )
                    :  Image.network(
            image,
            fit: BoxFit.cover,

            // ⏳ while loading
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              );
            },

            // ❌ broken / invalid URL
            errorBuilder: (context, error, stackTrace) {
              return Container( color: Colors.grey.shade200, child: const Center( child: Icon( Icons.broken_image_outlined, size: 50, color: Colors.grey, ), ), );
            },
          ),
              ),
            ),

            const SizedBox(height: 8),

            // 🏷 TITLE
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            // 💰 PRICE ROW
            Row(
              children: [
                // ✅ Selling Price (first size price)
                if (sellingPrice != null)
                  Text(
                    "₹${sellingPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),

                const SizedBox(width: 6),

                // ❌ Actual Price (strikethrough)
                Text(
                  "₹${actualPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 6),

                // 🔥 Discount Percentage
                if (discountPercent != null)
                  Text(
                    "${discountPercent.round()}% OFF",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            // 🛒 BUY NOW — fixed small height
            SizedBox(
              height: 28,
              width: double.infinity,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xfff3c0e6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "BUY NOW",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
