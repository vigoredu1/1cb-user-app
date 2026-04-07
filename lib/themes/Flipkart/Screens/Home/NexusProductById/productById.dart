import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/cart_controller.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/ProductById/flipkartProductById.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Cart/flipkartCart.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Flipkart/api/ProductById/productById.dart';
import 'package:one_click_builder/themes/Flipkart/api/cart/nexusAddtoCart.dart'
    as cartApi;
import 'package:one_click_builder/themes/Flipkart/utility/plugin_list.dart';

import 'package:shimmer/shimmer.dart';
import 'dart:io';

class ProductByIdScreen extends StatefulWidget {
  final String productId;
  const ProductByIdScreen({super.key, required this.productId});

  @override
  State<ProductByIdScreen> createState() => _ProductByIdScreenState();
}

class _ProductByIdScreenState extends State<ProductByIdScreen>
    with SingleTickerProviderStateMixin {
  bool isAddToCartLoading = false;
  bool isBuyNowLoading = false;

  Product? product;
  bool isLoading = true;

  final CartController cartController = Get.find<CartController>();

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
      final api = NexusProductById();
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

Future<void> _toggleWishlist() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    _showLoginRequiredDialog(context);
    return;
  }

  try {
    final selectedImage = product!.images[selectedColorIndex];

    final url =
        "https://api.1clickbuilder.com/api/wishlist/add-product-to-wishlist/${widget.productId}";

    final res = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
      body: jsonEncode({
        "productId": widget.productId,
        "vendorId": product!.vendorId,
        "productImageId": selectedImage.id,
      }),
    );

    final body = jsonDecode(res.body);

    print("Wishlist Status: ${res.statusCode}");
    print("Wishlist Body: ${res.body}");

    /// ✅ SUCCESS
    if (res.statusCode == 200 && body["data"] != null) {
      final message = body["data"]["message"];

      setState(() {
        isWishlisted = true;
      });

      _showSnack(message, backgroundColor: Colors.green);
    }

    /// ⚠️ ALREADY IN WISHLIST
    else if (body["error"] != null) {
      final message = body["error"]["message"];

      setState(() {
        isWishlisted = true;
      });

      _showSnack(message, backgroundColor: Colors.orange);
    }

    /// ❌ OTHER ERROR
    else {
      _showSnack("Wishlist failed", backgroundColor: Colors.red);
    }
  } catch (e) {
    print("Wishlist error: $e");
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

// Deduplicate colors and map to images
 // ---------------- COLOR → IMAGE → SIZE FLOW (FIXED) ----------------

Map<String, List<ProductImage>> colorMap = {};
bool hasRealColors = false;

for (var img in product!.images) {
  List<String> colors = img.colors;

  if (colors.isNotEmpty) {
    hasRealColors = true;
  }

  if (colors.isEmpty) {
    colors = ["default"];
  }

  for (var color in colors) {
    colorMap.putIfAbsent(color, () => []);
    colorMap[color]!.add(img);
  }
}

final List<String> uniqueColors = colorMap.keys.toList();
final bool hasColors = hasRealColors;

// SAFE selected color
String? selectedColor =
    hasColors && selectedColorIndex < uniqueColors.length
        ? uniqueColors[selectedColorIndex]
        : null;

// Images for selected color
final List<ProductImage> imagesForSelectedColor =
    selectedColor != null ? colorMap[selectedColor]! : product!.images;

// -------- SIZE LOGIC --------

Map<String, ProductSize> sizeMap = {};

for (var img in imagesForSelectedColor) {
  for (var s in img.sizes) {
    if (s.size != null && !sizeMap.containsKey(s.size)) {
      sizeMap[s.size!] = s;
    }
  }
}

final List<ProductSize> sizeList = sizeMap.values.toList();

final bool hasSizes = sizeList.isNotEmpty;
// ✅ ACTIVE PRICE & STOCK + ORIGINAL PRICE + DISCOUNT %

    double sellingPrice = 0;
    double originalPrice = 0;
    int discountPercent = 0;
    String stock = "0";

    if (hasSizes) {
      final selectedSize = sizeList[selectedSizeIndex];

      sellingPrice =
          double.tryParse(selectedSize.price?.toString() ?? "0") ?? 0;

      stock = selectedSize.stock ?? "0";

      originalPrice =
          double.tryParse(product!.price?.toString() ?? "0") ?? sellingPrice;
    } else if (product!.images.isNotEmpty) {
      final firstImage = product!.images.first;

      if (firstImage.sizes != null && firstImage.sizes!.isNotEmpty) {
        final firstSize = firstImage.sizes!.first;

        sellingPrice = double.tryParse(firstSize.price?.toString() ?? "0") ?? 0;

        stock = firstSize.stock ?? "0";
      }

      originalPrice =
          double.tryParse(product!.price?.toString() ?? "0") ?? sellingPrice;
    } else {
      sellingPrice = double.tryParse(product!.price?.toString() ?? "0") ?? 0;

      originalPrice = sellingPrice;
      stock = product!.currentStock?.toString() ?? "0";
    }

    if (originalPrice < sellingPrice) {
      originalPrice = sellingPrice;
    }

    discountPercent = originalPrice > 0
        ? (((originalPrice - sellingPrice) / originalPrice) * 100).round()
        : 0;

    String price = sellingPrice.toStringAsFixed(0);

// ✅ Carousel images based on selected color
    List<String> selectedColorImages = [];

    if (hasColors && imagesForSelectedColor.isNotEmpty) {
      selectedColorImages = imagesForSelectedColor
          .where((e) => e.image != null && e.image!.isNotEmpty)
          .map((e) => e.image!)
          .toList();
    } else {
      selectedColorImages = images
          .where((e) => e.image != null && e.image!.isNotEmpty)
          .map((e) => e.image!)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product!.title ?? "Product"),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.black,
            ),
            onPressed: _toggleWishlist,
          ),
          Obx(() {
            final prefs = Get.find<SharedPreferences>();
            final token = prefs.getString("token");

            // If token present → logged-in
            final count = token != null
                ? cartController.cartCount.value
                : guestCartController.guestCartCount.value;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => Get.to(() => const FlipkartCartScreen()),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: Colors.black, size: 26),
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
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // CAROUSEL (single image per color in current API)
          if (selectedColorImages.isNotEmpty)
            SizedBox(
              height: 560,
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
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                                const Center(child: Icon(Icons.broken_image)),
                          ),
                        ),
                      );
                    },
                  ),

                  // DOT INDICATOR (works even if there is just one dot)
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

            // Fallback: show first image from product images list (shouldn't usually happen)
            SizedBox(
              height: 360, // 👈 Flipkart doesn’t go too tall
              width: double.infinity,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Image.network(
                  product!.images.first.image!,
                  fit: BoxFit.contain,
                ),
              ),
            ),

          const SizedBox(height: 16),
          // SIZE SELECTOR
          if (hasSizes) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Select Size",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF2874F0)
                              : Colors.grey.shade400,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        size.size ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? const Color(0xFF2874F0)
                              : Colors.black87,
                        ),
                      ),
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

          const SizedBox(height: 8),

          // TITLE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              product!.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // PRICE + STOCK + CART ICON

          // PRICE + ORIGINAL PRICE + DISCOUNT %
// PRICE + ORIGINAL PRICE + DISCOUNT (MATCH YOUR DESIGN)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Selling Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "₹$sellingPrice",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (originalPrice > sellingPrice)
                      Text(
                        "₹$originalPrice",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(width: 8),
                    if (discountPercent > 0)
                      Text(
                        "$discountPercent% off",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),

                // Discount with arrow
              ],
            ),
          ),

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
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF2874F0)
                              : Colors.grey.shade300,
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

          const SizedBox(height: 28),

          // ADD TO CART BUTTON (bottom)
          // ================= PRODUCT DETAILS CARD =================
          if (product!.description != null &&
              product!.description!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Html(
                      data: product!.description!,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14),
                          lineHeight: LineHeight.number(1.6),
                          color: Colors.black87,
                        ),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ]),
      ),
      bottomNavigationBar: _buildBottomBar(price),
    );
  }

  Widget _buildBottomBar(String price) {
    return SafeArea(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🟡 ADD TO CART (Flipkart Yellow)
            Expanded(
              child: InkWell(
                onTap: isAddToCartLoading
                    ? null
                    : () async {
                        await _onAddToCartPressed(isBuyNow: false);
                      },
                child: Container(
                  color: const Color(0xFFFFC200),
                  alignment: Alignment.center,
                  child: isAddToCartLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "ADD TO CART",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),

            // 🟠 BUY NOW (Flipkart Orange)
            Expanded(
              child: InkWell(
                onTap: isBuyNowLoading
                    ? null
                    : () async {
                        final added = await _onAddToCartPressed(isBuyNow: true);
                        if (added) {
                          Get.to(() => const FlipkartCartScreen());
                        }
                      },
                child: Container(
                  color: const Color(0xFFFF9F00),
                  alignment: Alignment.center,
                  child: isBuyNowLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "BUY NOW\n",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "₹$price",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),
          ],
        ),
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
        selectedSize: selectedSizeData?.size ?? "",
      );

      switch (result) {
        case cartApi.CartAddResult.success:
          cartController.cartCount.value += 1;
          _showSnack("Item added to cart", backgroundColor: Colors.green);
          return true;

        case cartApi.CartAddResult.alreadyExists:
          _showSnack("Item already in your cart",
              backgroundColor: Colors.orange);
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
                MaterialPageRoute(builder: (_) => FlipkartSignInScreen()),
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

  Color _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return Colors.grey;
    }

    try {
      hex = hex.replaceAll("#", "");

      if (hex.length == 6) {
        hex = "FF$hex";
      }

      return Color(int.parse("0x$hex"));
    } catch (e) {
      return Colors.grey;
    }
  }

  Future<bool> _guestAddToCart() async {
    try {
      setState(() => isLoading = true); // 🔵 SHOW LOADER

      final prefs = await SharedPreferences.getInstance();
      final guestId = prefs.getString("guestId") ?? "";
      final vendorCtrl = Get.find<FlipkartVendorController>();
      final vendorId = vendorCtrl.vendorId.value;

      if (guestId.isEmpty) {
        print("⚠ No guestId found.");
        _showSnack("Something Went Wrong", backgroundColor: Colors.red);

        setState(() => isLoading = false); // 🔴 HIDE LOADER
        return false;
      }

      final String url =
          "https://api.1clickbuilder.com/api/cart/guest/add-cart/$vendorId/$guestId";

      final selectedImage = product!.images.isNotEmpty &&
              selectedColorIndex < product!.images.length
          ? product!.images[selectedColorIndex]
          : product!.images.first;

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

      if (selectedImage.colors.isNotEmpty) {
        body["selectedColor"] = selectedImage.colors.first;
      }

      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      final response = jsonDecode(res.body);

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
