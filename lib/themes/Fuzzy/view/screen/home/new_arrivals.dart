import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../../service/home/best_selling_product_api.dart';
import '../../../service/wishlist_api.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/images.dart';
import '../../../utility/svg_assets.dart';
import '../cart/abc.dart';
import '../product_detail/product_detail_screen.dart';

class NewArrivals extends StatefulWidget {
  const NewArrivals({super.key});

  @override
  State<NewArrivals> createState() => _NewArrivalsState();
}

class _NewArrivalsState extends State<NewArrivals> {
  String parseHtmlString(String? htmlString) {
    final document = parse(htmlString ?? '');
    return document.body?.text ?? '';
  }

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
      return const Center(child: Text(''));
    }

    if (bestSellerList.isEmpty) {
      return const Center(
        child: Text(
          "",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Arrivals',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        AppTheme.fromType(AppTheme.defaultTheme).primaryColor),
              ),
              Text(
                'View All ',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppTheme.fromType(AppTheme.defaultTheme).lightText),
              ),
            ],
          ),
        ),
        GridView.builder(
          itemCount: bestSellerList.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 12,
            childAspectRatio: 0.67,
          ),
          itemBuilder: (context, index) {
            final productData = bestSellerList[index];
            final product = productData.product;
            final rating = productData.product?.retailPrice ?? 0.0;
            // final product = productData.product;
            final variants = productData.variants ?? [];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                            product: product!,
                            variants: variants,
                          )),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.fromType(AppTheme.defaultTheme)
                      .backGroundColorMain,
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
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                color: AppTheme.fromType(AppTheme.defaultTheme)
                                    .searchBackground),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
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
                          ),

                          // Wishlist icon (top-right)
                          Positioned(
                            top: 0,
                            right: 14,
                            child: WishlistButton(
                              productId: product?.id ?? "",
                              productImageId: (product?.images != null &&
                                  product!.images!.isNotEmpty &&
                                  index < product.images!.length)
                                  ? product.images![index].id ?? " "
                                  : " ",  // Fallback if no images or index out of bounds
                            ),
                          ),

                          // Cart button (bottom-right)
                          Positioned(
                            bottom: 2,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                // Add to cart logic here
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
                                  color:
                                      AppTheme.fromType(AppTheme.defaultTheme)
                                          .whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    Container(
                      decoration: BoxDecoration(
                          // borderRadius: const BorderRadius.all(
                          //     Radius.circular(6)),
                          color: AppTheme.fromType(AppTheme.defaultTheme)
                              .searchBackground),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 8, bottom: 2),
                            child: Text(
                              product?.title ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Short description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              parseHtmlString(product?.description),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Price + Old Price + Rating
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  rating.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
