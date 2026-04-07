import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Amazon/Modules/ProductById/AmzProductById.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Cart/AmzCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Amazon/api/ProductById/productById.dart';
import 'package:one_click_builder/themes/Amazon/api/cart/AmzAddtoCart.dart'
    as api;
import 'package:one_click_builder/themes/Amazon/api/cart/AmzAddtoCart.dart'
    as cartApi;
import 'package:one_click_builder/themes/Amazon/utility/app_constant.dart';
import 'package:one_click_builder/themes/Amazon/utility/plugin_list.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

import '../../SearchScreren/AmzSearchScreen.dart';
import 'package:flutter/cupertino.dart';

class AmzProductByIdScreen extends StatefulWidget {
  final String productId;
  const AmzProductByIdScreen({super.key, required this.productId});

  @override
  State<AmzProductByIdScreen> createState() => _ProductByIdScreenState();
}

class _ProductByIdScreenState extends State<AmzProductByIdScreen>
    with SingleTickerProviderStateMixin {
  bool isAddToCartLoading = false;
  bool isBuyNowLoading = false;

  Product? product;
  bool isLoading = true;

  final AmzCartController cartController = Get.find<AmzCartController>();

  File? userImage;
  Offset productOffset = const Offset(100, 200);
  double productScale = 1.0;

  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;

  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentCarouselIndex = 0;
  final GuestCartController guestCartController =
      Get.find<GuestCartController>();

  bool isWishlisted = false;
  late AnimationController _addToCartController;
  double getDefaultSellingPrice(Product product) {
    try {
      if (product.images.isNotEmpty &&
          product.images.first.sizes.isNotEmpty &&
          product.images.first.sizes.first.price != null) {
        return product.images.first.sizes.first.price!.toDouble();
      }
    } catch (_) {}

    // last fallback only
    return double.tryParse(product.price?.toString() ?? "0") ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _addToCartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.9,
      upperBound: 1.05,
    )..value = 1.0;
//Get.put(GuestCartController());

    fetchProductData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _addToCartController.dispose();
    super.dispose();
  }

  bool isLoggedIn = false;
  bool isCheckingLogin = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        userImage = File(picked.path);
        productOffset = const Offset(100, 200);
        productScale = 1.0;
      });
    }
  }

  Future<void> fetchProductData() async {
    try {
      final api = AmzProductById();
      final fetchedProduct = await api.fetchProduct(widget.productId);
      await Future.delayed(const Duration(milliseconds: 250)); // small UX delay
      setState(() {
        product = fetchedProduct;
        isLoading = false;
        selectedColorIndex = 0;
        selectedSizeIndex = 0;
        _currentCarouselIndex = 0;
      });
    } catch (e) {
      debugPrint("Product fetch error: $e");
      setState(() {
        product = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildShimmer();

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product")),
        body: const Center(child: Text("Product not found")),
      );
    }

    final List<ProductImage> images = product!.images ?? [];

    // If there are no images at all, show fallback
    if (images.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product")),
        body: const Center(child: Text("No images available")),
      );
    }
// ---------------- COLOR → IMAGE → SIZE FLOW (FIXED) ----------------
    PreferredSizeWidget _buildAppBar() {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),

        title: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isEmpty) return;

              // search logic
              // searchCtrl.searchProduct(value);
              // Get.to(() => const SearchScreen());
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.black54),
              hintText: "Search here..",
              hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ),
        ),

        // ✅ CART ICON WITH BADGE
        actions: [
          Obx(() {
            final prefs = Get.find<SharedPreferences>();
            final token = prefs.getString("token");

            final count = token != null
                ? cartController.cartCount.value
                : guestCartController.guestCartCount.value;

            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () => Get.to(() => const AmzCartScreen()),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                      size: 26,
                    ),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      );
    }

// Deduplicate colors and map to images
    Map<String, List<ProductImage>> colorMap = {};

for (var img in product!.images ?? []) {
  if (img.colors.isEmpty) {
    // fallback color when no colors exist
    const fallbackColor = "no_color";

    if (!colorMap.containsKey(fallbackColor)) {
      colorMap[fallbackColor] = [];
    }

    colorMap[fallbackColor]!.add(img);
  } else {
    for (var color in img.colors) {
      if (!colorMap.containsKey(color)) {
        colorMap[color] = [];
      }
      colorMap[color]!.add(img);
    }
  }
}

  final List<String> uniqueColors =
    colorMap.keys.where((c) => c != "no_color").toList();

final bool hasColors = uniqueColors.isNotEmpty;

// ✅ SAFE selected color
    String selectedColor;

if (hasColors) {
  selectedColor = uniqueColors[selectedColorIndex];
} else {
  selectedColor = "no_color";
}

// ✅ SAFE images list
    final List<ProductImage> imagesForSelectedColor =
        selectedColor != null && colorMap[selectedColor] != null
            ? colorMap[selectedColor]!
            : [];

// Sizes for selected color
    final Map<String, ProductSize> sizeMap = {};

    for (var img in imagesForSelectedColor) {
      for (var s in img.sizes!) {
        if (s.size != null && !sizeMap.containsKey(s.size)) {
          sizeMap[s.size!] = s; // keep first occurrence
        }
      }
    }

    final List<ProductSize> sizeList = sizeMap.values.toList();

    final bool hasSizes =
        sizeList.isNotEmpty && selectedSizeIndex < sizeList.length;
// ✅ ACTIVE PRICE & STOCK + ORIGINAL PRICE + DISCOUNT %
    String price;
    String stock;
    double sellingPrice = 0;
    double originalPrice = 0;
    int discountPercent = 0;

    if (hasSizes) {
      // ✅ User has selected a size
      final selectedSize = sizeList[selectedSizeIndex];

      sellingPrice =
          selectedSize.price?.toDouble() ?? getDefaultSellingPrice(product!);

      stock = selectedSize.stock ?? product!.currentStock?.toString() ?? "0";
    } else {
      // ✅ Initial load (no size selected yet)
      sellingPrice = getDefaultSellingPrice(product!);
      stock = product!.currentStock?.toString() ?? "0";
    }

// Original price logic
    originalPrice = product!.price?.toDouble() ??
        product!.price?.toDouble() ??
        sellingPrice;

    if (originalPrice < sellingPrice) {
      originalPrice = sellingPrice;
    }

    discountPercent = originalPrice > 0
        ? (((originalPrice - sellingPrice) / originalPrice) * 100).round()
        : 0;

    price = sellingPrice.toString();

// ✅ Carousel images based on selected color
    final List<String> selectedColorImages = imagesForSelectedColor
        .where((e) => e.image != null && e.image!.isNotEmpty)
        .map((e) => e.image!)
        .toList();

    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // CAROUSEL (single image per color in current API)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              product!.title ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.1, // reduces vertical spacing
              ),
            ),
          ),
   if (selectedColorImages.isNotEmpty)
  AspectRatio(
    aspectRatio: 1,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: selectedColorImages.length,
          onPageChanged: (idx) {
            setState(() => _currentCarouselIndex = idx);
          },
          itemBuilder: (context, index) {
            final imgUrl = selectedColorImages[index];

            return GestureDetector(
              onTap: () => _openZoomableImage(context, imgUrl),
              child: Hero(
                tag: imgUrl,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade100, // ✅ background color
                  child: Center(
                    child: Image.network(
                      imgUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              width: 120,
                              height: 20,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        /// DOT INDICATOR
        Positioned(
          bottom: 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              selectedColorImages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentCarouselIndex == i ? 14 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentCarouselIndex == i
                      ? Colors.white
                      : Colors.white54,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        )
      ],
    ),
  )
else
  AspectRatio(
    aspectRatio: 1,
    child: Container(
      color: Colors.grey.shade100, // ✅ background here also
      child: Center(
        child: Image.network(
          product!.images.first.image ?? "",
          fit: BoxFit.contain,
          errorBuilder: (c, e, s) {
            return const Icon(Icons.broken_image, size: 50);
          },
        ),
      ),
    ),
  ),

          const SizedBox(height: 10),

          // TITLE

          // const SizedBox(height: 12),

          // PRICE + STOCK + CART ICON

          // PRICE + ORIGINAL PRICE + DISCOUNT %
// PRICE + ORIGINAL PRICE + DISCOUNT (MATCH YOUR DESIGN)
          _buildPricingSection(sellingPrice, originalPrice, discountPercent),
          const SizedBox(height: 18),
          // COLOR SELECTOR
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Select Color",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),

          if (hasColors)
            SizedBox(
              height: 54,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  final hex = uniqueColors[idx];
                  final bool selected = idx == selectedColorIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColorIndex = idx;
                        selectedSizeIndex = 0;
                        _currentCarouselIndex = 0;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? Colors.blue : Colors.grey.shade300,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: _hexToColor(hex),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: uniqueColors.length,
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "No color options available",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // SIZE SELECTOR
          if (hasSizes) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Select Size",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(sizeList.length, (i) {
                  final size = sizeList[i];
                  final selected = i == selectedSizeIndex;
                  return GestureDetector(
                    onTap: () => setState(() => selectedSizeIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(size.size ?? "",
                          style: TextStyle(
                              color: selected ? Colors.white : Colors.black)),
                    ),
                  );
                }),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Select Size",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "No size options available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
          const SizedBox(height: 14),

          _buildBottomBar(price),

          // const SizedBox(height: 14),

          // ADD TO CART BUTTON (bottom)
          // ================= PRODUCT DETAILS CARD =================
          if (product!.description != null &&
              product!.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildProductDescriptionCard()
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(14),
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade100,
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: Colors.grey.shade300),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           "Product Details",
            //           style:
            //           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //         const SizedBox(height: 10),
            //         Html(
            //           data: product!.description!,
            //           style: {
            //             "body": Style(
            //               margin: Margins.zero,
            //               padding: HtmlPaddings.zero,
            //               fontSize: FontSize(14),
            //               lineHeight: LineHeight.number(1.6),
            //               color: Colors.black87,
            //             ),
            //             "p": Style(
            //               margin: Margins.only(bottom: 8),
            //             ),
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],

          const SizedBox(height: 5),
        ]),
      ),
    );
  }

  Widget _buildPricingSection(double selling, double original, int discount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (discount > 0)
            Text(
              "-$discount%",
              style: const TextStyle(
                  color: Colors.red, fontSize: 24, fontWeight: FontWeight.w500),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "₹${selling.toInt()}",
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (original > selling)
            Text(
              "M.R.P.: ₹${original.toInt()}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough),
            ),
        ],
      ),
    );
  }

  Widget _buildProductDescriptionCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              const Color(0xFFF8F8F8), // Light grey background from screenshot
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Html(
              data: product!.description ?? "",
              style: {
                "body": Style(fontSize: FontSize(15), color: Colors.black87),
                "li": Style(margin: Margins.only(bottom: 4)),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          // color: Colors.white,
          // border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _onAddToCartPressed(isBuyNow: false),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF6750A4), // Purple from screenshot
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Add to cart",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _onAddToCartPressed(isBuyNow: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9900), // Orange "Buy Now"
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text("Buy Now",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
  // ---------- HELPERS & SMALL ANIMATIONS ----------

  void _simulateAddToCart() {
    _addToCartController.forward().then((_) => _addToCartController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to cart")),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('token');
    return userId != null && userId.isNotEmpty;
  }

  Future<bool> _onAddToCartPressed({required bool isBuyNow}) async {
    // Check login
    final loggedIn = await _checkLoginStatus();

    if (!loggedIn) {
      if (isBuyNow) {
        _showLoginRequiredDialog(context);
        return false;
      } else {
        print('guest cart execute if else');
        return await _guestAddToCart();
      }
    }

    // Normal add to cart flow
    if (product == null || product!.images.isEmpty) {
      _showSnack("Invalid product");
      return false;
    }

    setState(() {
      if (isBuyNow) {
        isBuyNowLoading = true;
      } else {
        isAddToCartLoading = true;
      }
    });

    try {
      final selectedImage = product!.images.isNotEmpty &&
              selectedColorIndex < product!.images.length
          ? product!.images[selectedColorIndex]
          : product!.images.first;

      final selectedColor =
          (selectedImage.colors.isNotEmpty) ? selectedImage.colors.first : "";

      final selectedSizeData = selectedSizeIndex < selectedImage.sizes.length
          ? selectedImage.sizes[selectedSizeIndex]
          : null;

      final result = await cartApi.CartApiService.addToCart(
        vendorId: product!.vendorId ?? "",
        productId: product!.id ?? "",
        image: selectedImage.image ?? "",
        isImported: (product!.isImported ?? 0) == 1,
        price: selectedSizeData?.price?.toInt() ?? 0,
        quantity: 1,
        selectedColor: selectedColor,
        selectedSize: selectedSizeData?.size ?? "Free",
      );

      switch (result) {
        case cartApi.CartAddResult.success:
          cartController.cartCount.value += 1;

          if (isBuyNow) {
            Get.to(() => const AmzCartScreen());
          } else {
            _showSnack("Item added to cart", backgroundColor: Colors.green);
          }

          return true;

        case cartApi.CartAddResult.alreadyExists:
          if (isBuyNow) {
            Get.to(() => const AmzCartScreen());
          } else {
            _showSnack("Item already in your cart",
                backgroundColor: Colors.orange);
          }

          return true;

        case cartApi.CartAddResult.notLoggedIn:
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          _showSnack("Session Expired", backgroundColor: Colors.blue);
          _showLoginRequiredDialog(context);
          return false;

        case cartApi.CartAddResult.error:
          _showSnack("Failed to add item", backgroundColor: Colors.red);
          return false;
      }
    } catch (e) {
      _showSnack("Something went wrong");
      return false;
    } finally {
      setState(() {
        isAddToCartLoading = false;
        isBuyNowLoading = false;
      });
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please login to access this feature."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AmzSignInScreen()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  void _showSnack(
    String message, {
    Color backgroundColor = Colors.black87,
  }) {
    Get.snackbar(
      "Cart",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void _openZoomableImage(BuildContext ctx, String url) {
    showDialog(
      context: ctx,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Dialog(
            backgroundColor: Colors.black87,
            insetPadding: const EdgeInsets.all(4),
            child: Hero(
              tag: url,
              child: InteractiveViewer(
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (c, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 120,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // shimmer loading scaffold
  Widget _buildShimmer() {
    return Scaffold(
      appBar: AppBar(title: const Text("Product")),
      body: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(height: 300, color: Colors.white),
            const SizedBox(height: 16),
            Container(height: 20, color: Colors.white),
            const SizedBox(height: 12),
            Container(height: 18, width: 120, color: Colors.white),
            const SizedBox(height: 20),
            Row(children: [
              Container(height: 40, width: 40, color: Colors.white),
              const SizedBox(width: 10),
              Container(height: 40, width: 40, color: Colors.white),
              const SizedBox(width: 10),
              Container(height: 40, width: 40, color: Colors.white),
            ]),
            const SizedBox(height: 20),
            Container(height: 40, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
  }

  Future<bool> _guestAddToCart() async {
    try {
      setState(() => isLoading = true); // 🔵 SHOW LOADER

      final prefs = await SharedPreferences.getInstance();
      final guestId = prefs.getString("guestId") ?? "";
      final vendorCtrl = Get.find<AmzVendorController>();
      final vendorId = vendorCtrl.vendorId.value;

      if (guestId.isEmpty) {
        print("⚠ No guestId found.");
        _showSnack("Something Went Wrong", backgroundColor: Colors.red);

        setState(() => isLoading = false); // 🔴 HIDE LOADER
        return false;
      }

      final String url =
          "${AmzAppConstant.baseUrl}/api/cart/guest/add-cart/$vendorId/$guestId";

      final selectedImage = product!.images.isNotEmpty &&
              selectedColorIndex < product!.images.length
          ? product!.images[selectedColorIndex]
          : product!.images.first;

      final selectedColor =
          (selectedImage.colors.isNotEmpty) ? selectedImage.colors.first : "";

      ProductSize? selectedSizeData;
      if (selectedSizeIndex < selectedImage.sizes.length) {
        selectedSizeData = selectedImage.sizes[selectedSizeIndex];
      }

      final Map<String, dynamic> body = {
        "vendorId": product!.vendorId ?? "",
        "productId": product!.id ?? "",
        "image": selectedImage.image ?? "",
        "price": selectedSizeData?.price?.toInt() ?? 0,
        "quantity": 1,
        "selectedSize": selectedSizeData?.size ?? "Free",
      };

// ✅ Add color ONLY if available
      if (selectedImage.colors.isNotEmpty) {
        body["selectedColor"] = selectedImage.colors.first;
      }

      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      final response = jsonDecode(res.body);

      print("hhhhhh${res.body}");

      if (res.statusCode == 200) {
        _showSnack("Item added to cart", backgroundColor: Colors.green);

        Get.find<GuestCartController>().loadGuestCart();

        return true;
      }

      final error = response["error"]?["error"];

      if (error == "ProductAlreadyInCart") {
        _showSnack("Item already in your cart", backgroundColor: Colors.orange);
        return true;
      }

      _showSnack("Failed to add item", backgroundColor: Colors.red);
      return false;
    } catch (e) {
      print("Guest add cart exception: $e");
      _showSnack("Something went wrong", backgroundColor: Colors.red);
      return false;
    } finally {
      setState(() => isLoading = false);
    }
  }
}
