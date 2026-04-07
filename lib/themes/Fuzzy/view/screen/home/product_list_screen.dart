import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core_widget/custom_checkbox.dart';
import '../../../core_widget/custom_pricerange_widget.dart';
import '../../../core_widget/custom_pricesort_widget.dart';
import '../../../data/model/product_list_model.dart';
import '../../../utility/local_storage.dart';
import 'logo_display.dart';

class ProductListScreen extends StatefulWidget {
  final ProductList product;
  final String title;

  const ProductListScreen({super.key, required this.product, required this.title});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  double min = 0;

  double _minPrice = 0;

  double _maxPrice = 10000;

  @override
  Widget build(BuildContext context) {
    final filteredImages = widget.product.images.where((image) {
      final price = widget.product.price;
      return price >= _minPrice && price <= _maxPrice;
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(""),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: LogoDisplay(), // your short logo widget
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      // drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              widget.title.isEmpty ? widget.product.categoryName : widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            /** Show only product sale code **/
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: CustomCheckbox(
                      label: '',
                      initialValue: false,
                      onChanged: (bool value) {
                        print("Selected: $value");
                      },
                    ),
                  ),
                  const Text(
                    "Show only products on shale",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            /** Price sorting code widget **/
            PriceSortWidget(
              onSortSelected: (sortType) {
                if (sortType == PriceSortType.lowToHigh) {
                  print("Sorting: Low to High");
                  // sort logic here
                } else {
                  print("Sorting: High to Low");
                  // sort logic here
                }
              },
            ),
            const SizedBox(height: 10),
            /** Product image url code widget **/
            SizedBox(
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (filteredImages!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No products available in range",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  if (filteredImages.isNotEmpty)
                    GridView.builder(
                      itemCount: widget.product.images.length - 1,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.45,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CupertinoColors.systemGrey4, width: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: Image.network(
                                      widget.product.productUrl,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image,
                                                  size: 150,
                                                  color: Colors.grey),
                                    )),
                                onTap: () {
                                  print("Explore collection");
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (_) => ProductDetailScreen(
                                  //           product: widget.product,
                                  //           variants: variants,
                                  //           title: '',
                                  //         )));
                                },
                              ),
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.product.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "${widget.product.price}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  'No Color available',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              /** Buy noe button code**/
                              GestureDetector(
                                onTap: () async {
                                  String? token =
                                      await StorageHelper.getToken();
                                  if (token != null) {
                                    print("Exist");
                                    // Proceed with next steps (navigate, purchase etc.)
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        elevation: 8,
                                        duration: const Duration(seconds: 3),
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        content: const Row(
                                          children: [
                                            Icon(Icons.lock_outline,
                                                color: Colors.white),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                'You are not signed in. Please log in to continue.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
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
                              )
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            /** Subcategory name **/
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    "Product Type",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    widget.product.subCategoryName,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                color: CupertinoColors.lightBackgroundGray,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    "Brand",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                    child: CustomCheckbox(
                      label: '',
                      initialValue: false,
                      onChanged: (bool value) {
                        print("Selected: $value");
                      },
                    ),
                  ),
                  Text(
                    widget.product.brandName.length <= 3
                        ? "Brand is Not available"
                        : widget.product.brandName,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Divider(
                color: CupertinoColors.lightBackgroundGray,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    "Price Range",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            PriceRangeSelector(
              minValue: 0,
              maxValue: 10000,
              onChanged: (range) {
                print('Price Range: ₹${range.start} - ₹${range.end}');
                print("max price: ${range.end}");
                setState(() {
                  _minPrice = range.start;
                  _maxPrice = range.end;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
