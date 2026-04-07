import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/FlipkartProducts/FlipkartProduct.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';

class Flipkartproductcard extends StatelessWidget {
  final Product product;

  const Flipkartproductcard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image = product.images.isNotEmpty ? product.images.first.image : '';

    final String? price =
        product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
            ? product.images.first.sizes.first.price
            : null;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            /// IMAGE
            AspectRatio(
  aspectRatio: 1,
  child: Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF4F6FA),
      borderRadius: BorderRadius.circular(14),
    ),
    padding: const EdgeInsets.all(10),
    child: image.isEmpty
        ? const Icon(Icons.image_not_supported)
        : Image.network(
            image,
            fit: BoxFit.contain,

            // Loading state
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },

            // Error state (404, invalid url etc)
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 30,
                  color: Colors.grey,
                ),
              );
            },
          ),
  ),
),
            const SizedBox(height: 8),

            /// TITLE
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 6),

            /// PRICE ROW
            Row(
              children: [
                if (price != null)
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(width: 6),
                Text(
                  "₹${product.discountPrice.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            /// ASSURED / OFFER BADGE (optional)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Assured",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
   
