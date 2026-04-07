import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/BestSellers/bestSellers.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';
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
    final String firstSizePrice = product.images.isNotEmpty &&
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
            builder: (_) => ProductByIdScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼 IMAGE (Flipkart style)
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: imageUrl.isEmpty
                    ? const Icon(Icons.image_not_supported, size: 40)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
              ),
            ),

            const SizedBox(height: 8),

            /// 🏷 TITLE
            Text(
              product.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 6),

            /// 💰 PRICE ROW (Flipkart style)
            Row(
              children: [
                Text(
                  "₹$firstSizePrice",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

            const SizedBox(height: 4),

            /// ✅ ASSURED TAG (optional but Flipkart-ish)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Assured",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2874F0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
