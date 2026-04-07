import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Fuzzy/view/screen/category/widget/bottomshhet.dart';
import 'package:svg_flutter/svg.dart';

import '../../../core_widget/common_button.dart';
import '../../../data/model/product_list_model.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/svg_assets.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductList product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  String removeHtmlTags(String? htmlText) {
    if (htmlText == null) return "No Description Available";
    final regex = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(regex, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      widget.product.productUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 150),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "20% Off",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.product.productName ?? "No Name",
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        "4.0",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "|",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "156 Reviews",
                        style: TextStyle(fontWeight: FontWeight.w100),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Price + Quantity buttons row
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "₹",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.product.price ?? 0}",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.1), // shadow color
                              spreadRadius: 1, // kitna spread kare shadow
                              blurRadius: 6, // softness of shadow
                              offset: const Offset(
                                  0, 3), // shadow ki direction (x, y)
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            const Text(
                              "|",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "|",
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "View Details",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            removeHtmlTags(widget.product.description) ??
                                "No Description Available",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    color: Colors.grey.shade300,
                    height: 3,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Check Delivery",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: SizedBox(
                                  height: 40,
                                  child: TextFormField(
                                    // validator: validator,
                                    // keyboardType: keyboardType,
                                    // focusNode: focusNode,
                                    decoration: InputDecoration(
                                        fillColor: AppTheme.fromType(AppTheme.defaultTheme)
                                            .searchBackground,
                                        filled: true,
                                        isDense: true,
                                        //input border
                                        disabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide.none),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide.none),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide.none),
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                            borderSide: BorderSide.none),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        prefixIcon: SvgPicture.asset(
                                          SvgAssets.iconSearch,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: AppTheme.fromType(AppTheme.defaultTheme).primaryColor.withOpacity(0.34)),
                                        hintText: 'Search Here'),
                                    // controller: productController.searchController,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: CommonButton(
                                      onTap: () {}, buttonText: "Check"))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 3,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.iconFastTruck,
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                      AppTheme.fromType(AppTheme.defaultTheme)
                                          .primaryColor,
                                      BlendMode.srcIn),
                                  height: 20,
                                  width: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  children: [
                                    Text(
                                      "Free",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "Delivery",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Center(
                                    child: SvgPicture.asset(
                                  SvgAssets.iconDollar,
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                      AppTheme.fromType(AppTheme.defaultTheme)
                                          .primaryColor,
                                      BlendMode.srcIn),
                                  height: 30,
                                  width: 30,
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  children: [
                                    Text(
                                      "COD",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "Available",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Center(
                                    child: SvgPicture.asset(
                                  SvgAssets.iconReturn,
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                      AppTheme.fromType(AppTheme.defaultTheme)
                                          .primaryColor,
                                      BlendMode.srcIn),
                                  height: 30,
                                  width: 30,
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  children: [
                                    Text(
                                      "21 Days",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      "Return",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      backgroundColor: Colors.white,
                      title: const Text(
                        "Reviews",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            removeHtmlTags(widget.product.description) ??
                                "No Description Available",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 3,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "+ Write Your Review",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        isScrollControlled:
                            true, // keyboard ke sath adjust hoga
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => const ReviewBottomSheet(),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white,
                      height: 50,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Similar Products",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  // const ItemWidget(),

                  const SizedBox(
                    height: 100,
                  ),

                  // const SizedBox(height: 80), // space for button
                ],
              ),
            ),
          ),

          // Bottom Add to Cart Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // Add to cart logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Added $quantity × ${widget.product.productName} to cart"),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SvgPicture.asset(
                        SvgAssets.iconDashboardCart,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                            AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                            BlendMode.srcIn),
                        height: 20,
                        width: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    const Text(
                      "|",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        "₹${widget.product.price ?? 0}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
