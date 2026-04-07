import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Fuzzy/utility/plugin_list.dart';
import 'package:one_click_builder/themes/Fuzzy/view/screen/category/productdetail_page.dart';


import '../../../controller/homepage/product_list_provider.dart';

class CategoryProducts extends StatelessWidget {
  final String category;

  const CategoryProducts({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductListController>();

    // filter products by given category
    final filteredProducts = productProvider.products
        .where((p) => p.categoryName == category)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // category title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // products list
          if (filteredProducts.isNotEmpty)
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.60,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  return InkWell(
                    onTap: () {
                      // TODO: Product detail navigation
                      // print(product.title);
                      // print(product.price);
                      print(product);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                    product: product,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image + Wishlist + Cart
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.215,
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    child: Image.network(
                                      product.productUrl,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(Icons.broken_image,
                                              size: 100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Wishlist icon (top-right)
                                // Positioned(
                                //   top: 0,
                                //   right: 14,
                                //   child: IconButton(
                                //     icon: const Icon(Icons.favorite_border,
                                //         color: Colors.red),
                                //     onPressed: () {
                                //       // TODO: wishlist logic
                                //     },
                                //   ),
                                // ),

                                // Cart button (bottom-right)
                                Positioned(
                                  bottom: 2,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      // TODO: add to cart logic
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.shopping_cart,
                                          size: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Title + description + price
                          Expanded(
                            child: Container(
                              color: Colors.grey.shade100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 8, bottom: 2),
                                    child: Text(
                                      product.productName ?? "No Name",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // Short description
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8),
                                  //   child: Text(
                                  //     product.description ?? "Modern arms...",
                                  //     style: TextStyle(
                                  //       fontSize: 12,
                                  //       color: Colors.grey.shade600,
                                  //     ),
                                  //     maxLines: 1,
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  // ),

                                  // Price + Old Price + Rating
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            "₹${product.price ?? 0}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 14),
                                          const SizedBox(width: 2),
                                          Text(
                                            (product.rating ?? 0).toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "No products in this category",
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
