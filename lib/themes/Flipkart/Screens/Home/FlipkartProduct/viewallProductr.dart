import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';

import '../../../Modules/FlipkartProducts/FlipkartProduct.dart';


class ViewAllProductsScreen extends StatelessWidget {
  final List<ProductData> products;

  const ViewAllProductsScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Products")),

      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width < 360 ? 0.60: 0.66,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = products[index].product;
          return NexusProductCard1(product: product!);
        },
      ),
    );
  }
}


class NexusProductCard1 extends StatelessWidget {
  final Product product;

  const NexusProductCard1({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final image =
        product.images.isNotEmpty ? product.images.first.image : "";

    final String? firstSizePrice =
        product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
            ? product.images.first.sizes.first.price
            : null;

    final double? sellingPrice =
        firstSizePrice != null ? double.tryParse(firstSizePrice) : null;

    final double? mrp = product.discountPrice != null
        ? double.tryParse(product.discountPrice.toString())
        : null;

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
            )
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
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8),
                child: image.isEmpty
                    ? const Icon(Icons.image_not_supported, size: 40)
                    : Image.network(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image_outlined),
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

            /// PRICE ROW (Flipkart clean style)
            Row(
              children: [
                if (firstSizePrice != null)
                  Text(
                    "₹$firstSizePrice",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(width: 6),
                if (mrp != null &&
                    sellingPrice != null &&
                    mrp > sellingPrice)
                  Text(
                    "₹${mrp.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 4),

            /// ASSURED TAG (optional Flipkart feel)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
