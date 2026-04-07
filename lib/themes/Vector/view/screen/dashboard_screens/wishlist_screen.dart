import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/view/screen/cart/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:svg_flutter/svg.dart';

import '../../../service/wishlist_api.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/images.dart';
import '../../../utility/svg_assets.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> with RouteAware {
  bool _isScreenOpened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// FETCH EVERY TIME SCREEN OPENS
    if (!_isScreenOpened) {
      _isScreenOpened = true;

      Future.microtask(() {
        Provider.of<WishlistProvider>(context, listen: false)
            .fetchWishlistProducts(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
        AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("Wishlist"),
          ),
          backgroundColor:
          AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Consumer<WishlistProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
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

            return RefreshIndicator(
              onRefresh: () async {
                await provider.fetchWishlistProducts(context);
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                itemCount: provider.wishlistProducts.length,
                itemBuilder: (context, index) {
                  final product = provider.wishlistProducts[index];

                  final String productId = product.id ?? "";

                  /// SAFE IMAGE ID
                  final String productImageId = (product.images != null &&
                      product.images!.isNotEmpty)
                      ? (product.images![0].id ?? "")
                      : "";

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.125,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.fromType(AppTheme.defaultTheme)
                                .searchBackground,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: Row(
                          children: [
                            /// IMAGE BOX
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height * 0.105,
                                width:
                                MediaQuery.of(context).size.width * 0.22,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppTheme.fromType(
                                      AppTheme.defaultTheme)
                                      .colorContainer,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    Images.image,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),

                            /// DETAILS
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.50,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      product.title ?? "No Title",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.fromType(
                                            AppTheme.defaultTheme)
                                            .primaryColor
                                            .withOpacity(0.40),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.60,
                                  child: Text(
                                    "Qty : 1",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.fromType(
                                          AppTheme.defaultTheme)
                                          .primaryColor
                                          .withOpacity(0.40),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.60,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "₹${product.salePrice ?? product.price ?? 0}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.fromType(
                                            AppTheme.defaultTheme)
                                            .primaryColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// REMOVE BUTTON
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            SvgAssets.iconClose,
                            fit: BoxFit.scaleDown,
                            color: AppTheme.fromType(AppTheme.defaultTheme)
                                .primaryColor,
                          ),
                          onPressed: () {
                            provider.removeWishlistItem(
                              productId: productId,
                              context: context,
                              productImageId: productImageId,
                            );
                          },
                        ),
                      ),

                      /// ADD TO CART BUTTON
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CartScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.075,
                              right: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1,
                                color: AppTheme.fromType(
                                    AppTheme.defaultTheme)
                                    .primaryColor
                                    .withOpacity(0.07),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.fromType(
                                      AppTheme.defaultTheme)
                                      .shadowColorThree,
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                SvgAssets.iconCartFill,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
