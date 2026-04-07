import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/NexusProductById/productById.dart';
import 'package:one_click_builder/themes/Flipkart/api/Wishlist/Whislist.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/wishlist/nexusproductWhislist.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Flipkart/utility/plugin_list.dart';


class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  final FlipkartVendorController vendorController =
      Get.find<FlipkartVendorController>();

  List<Product> wishlist = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }
  Future<bool> removeFromWishlist({
  required String productId,
  required String vendorId,
  required String productImageId,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url =
        "https://api.1clickbuilder.com/api/wishlist/remove-product/$productId/$vendorId";

    final res = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": token ?? "",
      },
      body: jsonEncode({
        "productImageId": productImageId,
      }),
    );

    print("DELETE STATUS: ${res.statusCode}");
    print("DELETE BODY: ${res.body}");

    return res.statusCode == 200;
  } catch (e) {
    print("DELETE ERROR: $e");
    return false;
  }
}

  Future<void> _loadWishlist() async {

    final vendorId = vendorController.vendorId.value;

    final response = await WishlistService().getWishlist(vendorId);

    if (!mounted) return;

    setState(() {
      wishlist = response?.data?.products ?? [];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (wishlist.isEmpty) {
      return Scaffold(
              appBar: AppBar(),

        body: const Center(child: Text("No wishlist items found")));
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: wishlist.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.67,
          ),
          itemBuilder: (context, index) {
        
            final product = wishlist[index];
        
           return Flipkartproductcard(
  product: product,
  onDelete: () async {

    final vendorId = vendorController.vendorId.value;

    final productImageId =
        product.images.isNotEmpty ? product.images.first.id : "";
final success = await removeFromWishlist(
      productId: product.id,
      vendorId: vendorId,
      productImageId: productImageId,
    );

    if (success) {
      _loadWishlist(); // refresh wishlist
    }
  },
);
          },
        ),
      ),
    );
  }
}


class Flipkartproductcard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const Flipkartproductcard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final image =
        product.images.isNotEmpty ? product.images.first.image : "";

final String price = product.price.toString();

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductByIdScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// IMAGE
            AspectRatio(
  aspectRatio: 1,
  child: Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(10),
        child: image.isEmpty
            ? const Icon(Icons.image_not_supported)
            : Image.network(
                image,
                fit: BoxFit.contain,
              ),
      ),

      /// DELETE BUTTON
      Positioned(
        top: 4,
        right: 4,
        child: GestureDetector(
onTap: () {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Remove Item"),
        content: const Text("Remove this product from wishlist?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text("Remove"),
          ),
        ],
      );
    },
  );
},
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delete,
              size: 18,
              color: Colors.red,
            ),
          ),
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 8),

            /// TITLE
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 6),

            /// PRICE ROW
            Row(
              children: [
                if (price != null)
                  Text(
                    "₹$price",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(width: 6),
              
              ],
            ),

            const SizedBox(height: 4),

            /// ASSURED / OFFER BADGE (optional)
        
          ],
        ),
      ),
    );
  }
}
   