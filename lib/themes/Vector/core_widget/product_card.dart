// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../../utility/images.dart';
//
// import '../../../controller/userprofile_provider.dart';
// import 'package:provider/provider.dart';
//
// import '../view/screen/authentication/login/login_page.dart';
// import '../view/screen/cart/abc.dart';
// import '../view/screen/checkout_screen/checkout_controller.dart';
// import '../view/screen/checkout_screen/checkout_screen.dart';
// import '../view/screen/product_detail/product_detail_screen.dart';
//
// class ProductCard extends StatelessWidget {
//   final dynamic product;
//   final List<dynamic> variants;
//   final VoidCallback? onTap;
//
//   const ProductCard({
//     super.key,
//     required this.product,
//     this.variants = const [],
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap ??
//               () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => ProductDetailScreen(
//                   product: product,
//                   // variants: variants,
//                 ),
//               ),
//             );
//           },
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: CupertinoColors.systemGrey4, width: 0.5),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   child: product.images != null &&
//                       product.images!.isNotEmpty &&
//                       product.images!.first.image != null
//                       ? Image.network(
//                     product.images!.first.image!,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   )
//                       : Image.asset(
//                     Images.image,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 WishlistButton(productId: product.id ?? ""),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               product.title ?? '',
//               style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Text(
//               '₹ ${product.price ?? 0}',
//               style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//             ),
//             const SizedBox(height: 4),
//             if (variants.isNotEmpty)
//               Wrap(
//                 spacing: 4,
//                 runSpacing: 4,
//                 children: variants.map((variant) {
//                   return Text(
//                     variant.variantName ?? 'No color available',
//                     style: const TextStyle(fontSize: 12),
//                   );
//                 }).toList(),
//               )
//             else
//               const Text(
//                 'No variants available',
//                 style: TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
//               ),
//             const Spacer(),
//             Consumer<UserProvider>(
//               builder: (context, userProvider, child) {
//                 return GestureDetector(
//                   onTap: () {
//                     if (userProvider.userResponse != null) {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => CheckoutScreen(
//                             controller: CheckoutController(),
//                             product: product,
//                           ),
//                         ),
//                       );
//                     } else {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text("Not Logged In"),
//                             content: const Text(
//                                 "You are not logged in. Please login to continue."),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text("Cancel"),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (context) => const LoginPage(),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text("Login"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                   },
//                   child: Container(
//                     height: 36,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: CupertinoColors.black,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       'Buy Now',
//                       style: TextStyle(
//                         color: CupertinoColors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
