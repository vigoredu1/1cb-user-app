
import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Modules/AmzProducts/AmzProduct.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/AmzProductById/productById.dart';

class AmzProductCard extends StatelessWidget {
  final Product product;

  const AmzProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.images.isNotEmpty ? product.images.first.image : '';

    final String? firstSizePrice =
    product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
        ? product.images.first.sizes.first.price
        : null;

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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT for vertical list
          children: [
            // 🔴 DEAL TAG
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Deal",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // 🖼 IMAGE (fixed height)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 150, // ✅ fixed height (no jump)
                width: double.infinity,
                child: image.isEmpty
                    ? Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_outlined,
                      size: 50, color: Colors.grey),
                )
                    : Image.network(
                  image,
                  fit: BoxFit.contain,
                  loadingBuilder:
                      (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child:
                      CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
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

            const SizedBox(height: 4),

            // 📝 TITLE
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            // 💰 PRICE
            Row(
              children: [
                if (firstSizePrice != null)
                  Text(
                    "₹$firstSizePrice",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(width: 6),
                Text(
                  "₹${product.discountPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),

            // 🔥 DISCOUNT %
            if (firstSizePrice != null)
              (() {
                final double selling = double.tryParse(firstSizePrice) ?? 0;
                final double original = product.discountPrice;

                if (original <= selling) return const SizedBox.shrink();

                final percent =
                    ((original - selling) / original) * 100;

                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "-${percent.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              })(),

            const SizedBox(height: 2),

            const Text(
              "Limited time deal",
              style: TextStyle(
                fontSize: 11,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
