import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Cart/AmzCart.dart';

// class CartItemTile extends StatelessWidget {
//   final CartItem item;

//   const CartItemTile({
//     super.key,
//     required this.item,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final CartController cartCtrl = Get.find<CartController>();

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // IMAGE
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Image.network(
//             item.image,
//             width: 90,
//             height: 120,
//             fit: BoxFit.cover,
//           ),
//         ),

//         const SizedBox(width: 16),

//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 item.name,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),

//               const SizedBox(height: 8),
//               Text("Size: ${item.size}"),

//               const SizedBox(height: 4),
//               Row(
//                 children: [
//                   const Text("Color: "),
//                   CircleAvatar(
//                     radius: 7,
//                     backgroundColor: item.color,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               /// PRICE + QTY + TOTAL
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "₹${item.price}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),

//                   /// QTY CONTROLS
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.remove),
//                         onPressed: () => cartCtrl.decreaseQtyByItem(item),
//                       ),
//                       Text(item.qty.toString()),
//                       IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () => cartCtrl.increaseQtyByItem(item),
//                       ),
//                     ],
//                   ),

//                   Text(
//                     "₹${item.total}",
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),

//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.red),
//                     onPressed: () => cartCtrl.removeItemByItem(item),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
