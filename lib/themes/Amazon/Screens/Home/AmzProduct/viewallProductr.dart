import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/AmzProductById/productById.dart';

import '../../../Modules/AmzProducts/AmzProduct.dart';

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
          childAspectRatio:
              MediaQuery.of(context).size.width < 360 ? 0.60 : 0.70,
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
    final image = product.images.isNotEmpty ? product.images.first.image : "";

    final String? firstSizePrice =
        product.images.isNotEmpty && product.images.first.sizes.isNotEmpty
            ? product.images.first.sizes.first.price
            : null;
    double? sellingPrice =
        firstSizePrice != null ? double.tryParse(firstSizePrice) : null;

    double? mrp = product.discountPrice != null
        ? double.tryParse(product.discountPrice.toString())
        : null;

    double? discountPercent;

    if (sellingPrice != null && mrp != null && mrp > 0 && mrp > sellingPrice) {
      discountPercent = ((mrp - sellingPrice) / mrp) * 100;
    }

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
            // IMAGE - flexible height inside grid item

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1.4, // maintain square shape, adjust as needed
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  // Show dummy while loading
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
                  // Show broken image if URL fails
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // TITLE + PRICE - Flexible
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
         FittedBox(
  fit: BoxFit.scaleDown,
  alignment: Alignment.centerLeft,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (firstSizePrice != null)
        Text(
          "₹$firstSizePrice",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),

      if (product.discountPrice != null) ...[
        const SizedBox(width: 6),
        Text(
          "₹${product.discountPrice}",
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
            fontSize: 8,
          ),
        ),
      ],

      if (discountPercent != null) ...[
        const SizedBox(width: 4),
        Text(
          "${discountPercent!.toStringAsFixed(0)}%",
          style: const TextStyle(
            color: Colors.green,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(
          Icons.arrow_downward,
          size: 12,
          color: Colors.green,
        ),
      ],
    ],
  ),
),

                ],
              ),
            ),

            // BUY NOW BUTTON - fixed height
            Container(
              width: double.infinity,
              height: 35,
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
          ],
        ),
      ),
    );
  }
}
