// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:one_click_builder/themes/Nexus/Modules/Nexus-Sub-Category/Nexus-sub-Category.dart';
// import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
// import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProductById/productById.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../../api/SubCategory/FlipkartGetSubCategory.dart';

// class AllSubCategory extends StatefulWidget {
//   final String subcategoryId;
//   final String subcategoryName;

//   const AllSubCategory({
//     super.key,
//     required this.subcategoryId,
//     required this.subcategoryName,
//   });

//   @override
//   State<AllSubCategory> createState() => _AllSubCategoryState();
// }

// class _AllSubCategoryState extends State<AllSubCategory> {
//   bool loading = true;
//   List<ProductData> products = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Color _hexToColor(String hex) {
//     hex = hex.replaceAll("#", "");
//     if (hex.length == 6) hex = "FF$hex";
//     return Color(int.parse("0x$hex"));
//   }

//   Future<void> fetchProducts() async {
//     final api = ProductApiService();
//     final vendorId = Get.find<NexusVendorController>().vendorId.value;

//     final response = await api.fetchProducts(
//       categoryId: vendorId,
//       search: widget.subcategoryName,
//     );

//     setState(() {
//       products = response;
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(title: Text(widget.subcategoryName)),
//       body: loading
//           ? Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey.shade300,
//                 highlightColor: Colors.grey.shade100,
//                 child: Container(
//                   width: 120,
//                   height: 20,
//                   color: Colors.white,
//                 ),
//               ),
//             )
//           : Row(
//               children: [
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: products.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       //  mainAxisExtent: 390,
//                       crossAxisSpacing: 20,
//                       mainAxisSpacing: 20,
//                       childAspectRatio: width < 360 ? 0.52 : 0.55,
//                     ),
//                     itemBuilder: (context, i) => _buildProductCard(products[i]),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   // ------------------------------------------------------------
//   // FIXED PRODUCT CARD → FULL NULL SAFETY
//   // ------------------------------------------------------------
//   Widget _buildProductCard(ProductData item) {
//     final product = item.product;

//     final String title = product!.title ?? "No Title";

//     List<String> allColors = [];

//     if (product.images != null && product.images!.isNotEmpty) {
//       for (var img in product.images!) {
//         if (img.colors != null && img.colors!.isNotEmpty) {
//           allColors.addAll(img.colors!);
//         }
//       }
//     }

// // Remove duplicates
//     allColors = allColors.toSet().toList();

//     // ---------------- SAFE IMAGE ----------------
//     final String imageUrl = product.images != null &&
//             product!.images!.isNotEmpty &&
//             product.images!.first.image != null
//         ? product.images!.first.image!
//         : "";

//     // ---------------- SAFE PRICE ----------------
//   // ---------------- SAFE PRICE (ALWAYS FROM IMAGE → SIZE) ----------------
// // ---------------- SAFE PRICE (ALWAYS FROM IMAGE → SIZE) ----------------
// double rawPrice = 0;

// if (product.images != null &&
//     product.images!.isNotEmpty &&
//     product.images!.first.sizes != null &&
//     product.images!.first.sizes!.isNotEmpty &&
//     product.images!.first.sizes!.first.price != null) {
//   rawPrice = double.tryParse(
//           product.images!.first.sizes!.first.price!.toString()) ??
//       0;
// } else {
//   rawPrice = (product.price ?? 0).toDouble();
// }

// // UI price
// final int displayPrice = rawPrice.round();

// // MRP
// final int mrp = product.mrpPrice ?? displayPrice;

// // Discount %
// final int discount =
//     mrp > displayPrice ? (((mrp - displayPrice) / mrp) * 100).round() : 0;



//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProductByIdScreen(productId: product.id.toString()),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white,
//           boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // IMAGE
//             AspectRatio(
//               aspectRatio: 1,
//               child: Image.network(
//                 imageUrl,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) =>
//                     const Icon(Icons.image, size: 60, color: Colors.grey),
//               ),
//             ),

//             // CONTENT AREA (flexible)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // TITLE
//                   Padding(
//                     padding: const EdgeInsets.all(8),
//                     child: Text(
//                       title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),

//                   // PRICE
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Row(
//                       children: [
//                         Text(
//                           "₹$displayPrice",
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(width: 6),
//                         if (mrp > displayPrice)
//                           Text(
//                             "₹$mrp",
//                             style: const TextStyle(
//                               fontSize: 9,
//                               color: Colors.grey,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                         const SizedBox(width: 6),
//                         if (discount > 0)
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 6, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade600,
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   "$discount%",
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 3),
//                                 const Icon(
//                                   Icons.arrow_downward,
//                                   color: Colors.white,
//                                   size: 10,
//                                 ),
//                               ],
//                             ),
//                           )
//                       ],
//                     ),
//                   ),

//                   const Spacer(), // ✅ now works perfectly

//                   // BUY BUTTON
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 10),
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: const Color(0xfff3c0e6),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.all(8),
//                       child: const Center(
//                         child: Text(
//                           "BUY NOW",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
