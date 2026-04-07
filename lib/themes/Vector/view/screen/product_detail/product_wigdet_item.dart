import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:one_click_builder/themes/Vector/service/wishlist_api.dart';
import 'package:one_click_builder/themes/Vector/view/screen/cart/abc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:svg_flutter/svg.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../service/home/best_selling_product_api.dart';
import '../../../utility/images.dart';
import '../../../utility/svg_assets.dart';

class ProductWidgetItem extends StatefulWidget {
  const ProductWidgetItem({super.key});

  @override
  State<ProductWidgetItem> createState() => _ProductWidgetItemState();
}

class _ProductWidgetItemState extends State<ProductWidgetItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BestSellingProductProvider>(context, listen: false)
          .fetchBestSellerProducts();
      Provider.of<WishlistProvider>(context, listen: false).fetchWishlistIds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<BestSellingProductProvider>(context);
    final bestSellerList = productProvider.bestSellerModel?.data ?? [];

    if (productProvider.isLoading) {
      return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
    }

    if (bestSellerList.isEmpty) {
      return const Center(
        child: Text(
          "No best sellers available.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      itemCount: bestSellerList.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final productData = bestSellerList[index];
        final product = productData.product;
        final variants = productData.variants ?? [];
        final rating = productData.product?.retailPrice ?? 0.0;

        return InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => ProductDetailScreen(
            //       product: product,
            //       variants: variants,
            //     ),
            //   ),
            // );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
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
                // IMAGE + ICONS
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.215,
                  child: Stack(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: product?.images != null &&
                            product!.images!.isNotEmpty &&
                            product.images!.first.image != null
                            ? Image.network(
                          product.images!.first.image!,
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

                      // Wishlist Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: WishlistButton(
                          productId: product?.id ?? "", productImageId: "${product?.images?[index].id}",
                        ),
                      ),

                      // Cart Button
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            // Add to cart logic
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              SvgAssets.iconCart,
                              height: 18,
                              width: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // TITLE
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    product?.title ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // PRICE + OLD PRICE + RATING
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        "₹${product?.price ?? 0}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (product?.costPrice != null)
                        Text(
                          "₹${product!.costPrice!}",
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
                        rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // BUY NOW BUTTON
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return GestureDetector(
                        onTap: () {
                          // if (userProvider.userResponse != null) {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => CheckoutScreen(
                          //         controller: CheckoutController(),
                          //         product: ,
                          //       ),
                          //     ),
                          //   );
                          // } else {
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: const Text("Not Logged In"),
                          //         content: const Text(
                          //             "You are not logged in. Please login to continue."),
                          //         actions: [
                          //           TextButton(
                          //             onPressed: () =>
                          //                 Navigator.of(context).pop(),
                          //             child: const Text("Cancel"),
                          //           ),
                          //           TextButton(
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //               Navigator.of(context).push(
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                   const LoginPage(),
                          //                 ),
                          //               );
                          //             },
                          //             child: const Text("Login"),
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          // }
                        },
                        child: Container(
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
