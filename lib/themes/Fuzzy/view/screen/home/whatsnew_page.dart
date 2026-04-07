import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../../controller/homepage/product_list_provider.dart';
import '../../../data/model/product_list_model.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/images.dart';
import '../../../utility/svg_assets.dart';
import '../cart/abc.dart';
import 'package:html/parser.dart' as htmlParser;

import '../product_detail/product_detail_screen.dart';

class WhatsNew extends StatefulWidget {
  const WhatsNew({super.key});

  @override
  State<WhatsNew> createState() => _WhatsNewState();
}

class _WhatsNewState extends State<WhatsNew> {
  String? _selectedCategory;
  String parseHtmlString(String? htmlString) {
    final document = htmlParser.parse(htmlString ?? '');
    return document.body?.text ?? '';
  }
  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductListController>();
    final categories = _getUniqueCategories(productProvider.products);

    // // default category select karo
    if (_selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }

    // filter products by selected category
    final filteredProducts = productProvider.products
        .where((p) => p.categoryName == _selectedCategory)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // categories

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.fromType(AppTheme.defaultTheme).primaryColor
                            : AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
                        border: Border.all(
                          color: AppTheme.fromType(AppTheme.defaultTheme)
                              .lightText
                              .withOpacity(0.25),
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.fromType(AppTheme.defaultTheme).searchBackground
                              : AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // products
        if (filteredProducts.isNotEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35, // thoda zyada height kyunki ab card me details bhi hain
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
// print(' product.images![index].image!');
// print( product.images![index].image!);
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => ProductDetailScreen(
                    //         product: product,
                    //         variants: product.variants ?? [], // agar model me hai
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: Container(
                      width: 180,
                      decoration: BoxDecoration(
                        color: AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
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
                            height: 160,
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                    color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                                    child: product.images.isNotEmpty &&
                                        product.images.first.image != null
                                        ? Image.network(
                                      product.images.first.image!,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      Images.image,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Wishlist icon
                                Positioned(
                                  top: 6,
                                  right: 12,
                                  child: WishlistButton(
                                    productId: product.id ?? "",
                                    productImageId: product.images.isNotEmpty
                                        ? product.images.first.id ?? ""
                                        : "",  // Fallback if no images
                                  ),
                                ),
                                // Cart button
                                Positioned(
                                  bottom: 6,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Add to cart logic
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        SvgAssets.iconCart,
                                        height: 18,
                                        width: 18,
                                        color: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Product details
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    product.title ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // Description
                                  Text(
                                    parseHtmlString(product.description),
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),


                                  const SizedBox(height: 4),

                                  // Price + Old Price + Rating
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product.price ?? 0}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "₹${product.costPrice!}",
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                      const SizedBox(width: 2),
                                      Text(
                                        (product.rating ?? 0).toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
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
          )

        else
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(""
                // "No products in this category"
                ""),
          ),
      ],
    );
  }

  List<String> _getUniqueCategories(List<ProductList> products) {
    return products
        .map((p) => p.categoryName ?? "Uncategorized")
        .toSet()
        .toList();
  }
}
