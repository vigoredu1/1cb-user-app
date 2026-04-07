import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/view/screen/productorder_page.dart';
import 'package:one_click_builder/themes/Vector/widget/common_button.dart';
import 'package:provider/provider.dart';

import '../../controller/product_detail_provider.dart';

// Function to strip HTML tags
String stripHtmlTags(String htmlString) {
  final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String description;
  final String title;
  final double price;
  final String brandname;
  final String images; // URL for the product image

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.brandname,
    required this.description,
    required this.images,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Product Detail",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ProductDetailProvider>(
        builder: (context, provider, child) {
          // Use the data passed via the widget instead of provider.productDetail
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image with fallback for error.
                Center(
                  child: Image.network(
                    images,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/dummy.png', // Ensure this asset exists
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Product title.
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Product price row with like icon.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: ₹$price",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: provider.isLiked
                            ? Colors.red
                            : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        provider.toggleLike();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Brand information.
                Text(
                  "Brand: $brandname",
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(height: 10),
                // Dummy review row with star icon.
                const Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      "4.5 (200 reviews)",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Dropdown button for description.
                GestureDetector(
                  onTap: () {
                    provider.toggleDescription();
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          provider.descriptionExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Show product description if expanded.
                if (provider.descriptionExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      stripHtmlTags(description),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                const SizedBox(height: 10),
                const Text(
                  "Get It Today",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                // Row for feature items.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureItem(
                        icon: Icons.local_shipping, label: "Free Shipping"),
                    _buildFeatureItem(
                        icon: Icons.support_agent, label: "Support Every Day"),
                    _buildFeatureItem(
                        icon: Icons.cached, label: "100 Day Return"),
                  ],
                ),
                const SizedBox(height: 30),
                // Buy Now button.
                SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductOrderPage(),
                            ),
                          );
                        },
                        buttonText: "Buy Now")),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildFeatureItem({required IconData icon, required String label}) {
  return Column(
    children: [
      Icon(
        icon,
        size: 28,
        color: Colors.black87,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}
