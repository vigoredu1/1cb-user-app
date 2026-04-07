import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:svg_flutter/svg.dart';

import '../../../controller/homepage/product_list_provider.dart';
import '../../../data/model/product_list_model.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/svg_assets.dart';
import 'category_product_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductListController>();
    final categories = _getUniqueCategories(productProvider.products);

    return Consumer<ProductListController>(
      builder: (_, controller, __) {
        if (controller.isLoading) {
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

        if (controller.products.isEmpty) {
          return const Center(
            child: Text(
              "No Products Available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Center(child: Text("Categories")),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    // onTap: AppDrawer(),
                    child: Container(
                        height: 40,
                        width: 40,
                        //decoration
                        decoration: BoxDecoration(
                            color: AppTheme.fromType(AppTheme.defaultTheme)
                                .colorContainer,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .primaryColor
                                  .withOpacity(0.1),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      AppTheme.fromType(AppTheme.defaultTheme)
                                          .shadowColorThree,
                                  spreadRadius: 2,
                                  blurRadius: 8)
                            ]),
                        //svg icon
                        child: Center(
                            child: SvgPicture.asset(
                          SvgAssets.iconTopNotification,
                          fit: BoxFit.scaleDown,
                          height: 20,
                          width: 20,
                        )))),
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      fillColor: AppTheme.fromType(AppTheme.defaultTheme)
                          .searchBackground,
                      filled: true,
                      isDense: true,
                      //input border
                      disabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide.none),
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide: BorderSide.none),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
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
                          color: AppTheme.fromType(AppTheme.defaultTheme)
                              .primaryColor
                              .withOpacity(0.34)),
                      hintText: 'Search Here'),
                  // controller: productController.searchController,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return InkWell(
                      onTap: () {
                        print(category);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryProducts(category: category),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  color: Colors.grey.shade100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          category, // ✅ ab unique category name aayega
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text(
                                          "Explore now →",
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // ==== IMAGE COLUMN ====
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    // ✅ ek representative product image dikhane ke liye
                                    productProvider.products
                                            .firstWhere(
                                              (p) => p.categoryName == category,
                                              orElse: () => productProvider
                                                  .products.first,
                                            )
                                            .productUrl ??
                                        "",
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.broken_image,
                                          size: 100, color: Colors.grey),
                                    ),
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
            ],
          ),
        );
      },
    );
  }

  List<String> _getUniqueCategories(List<ProductList> products) {
    return products
        .map((p) => p.categoryName ?? "Uncategorized")
        .toSet()
        .toList();
  }
}
