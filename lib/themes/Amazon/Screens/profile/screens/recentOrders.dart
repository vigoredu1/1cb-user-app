// import 'package:flutter/material.dart';
// import 'package:one_click_builder/themes/Nexus/Modules/orders/AmzOrders.dart';

// class RecentOrdersTable extends StatelessWidget {
//   final List<OrderModel> orders;

//   const RecentOrdersTable({super.key, required this.orders});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: orders.length,
//       padding: const EdgeInsets.all(12),
//       itemBuilder: (context, index) {
//         return OrderRow(order: orders[index]);
//       },
//     );
//   }
// }
// class OrderRow extends StatelessWidget {
//   final OrderModel order;
//   const OrderRow({super.key, required this.order});
  
//   get DateFormat => null;

//   @override
//   Widget build(BuildContext context) {
//     final product = order.products.isNotEmpty ? order.products.first : null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(10),
//       ),

//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Image
//          ClipRRect(
//   borderRadius: BorderRadius.circular(10),
//   child: Image.network(
//     product?.image?.isNotEmpty == true ? product!.image : "https://via.placeholder.com/70",
//     height: 70,
//     width: 70,
//     fit: BoxFit.cover,
//     errorBuilder: (context, error, stackTrace) {
//       return Image.asset(
//         "https://via.placeholder.com/70", // your fallback asset
//         height: 70,
//         width: 70,
//         fit: BoxFit.cover,
//       );
//     },
//   ),
// )
// ,
//           const SizedBox(width: 14),

//           // PRODUCT DETAILS
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product?.name ?? '',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 Text(
//                   product?.category ?? '',
//                   style: TextStyle(color: Colors.grey.shade600),
//                 ),

//                 Text(
//                   "${product?.quantity ?? 0} items",
//                   style: TextStyle(color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),

//           // PRICE + DATE
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "₹${order.price}",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 _formatDate(order.createdAt),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 _formatTime(order.createdAt.toString()),
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//             ],
//           ),

//           const SizedBox(width: 10),

//           // STATUS
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               InkWell(
//                 onTap: () {},
//                 child: const Text(
//                   "Check",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               Text(
//                 "Status",
//                 style: TextStyle(color: Colors.blue.shade700),
//               ),
//             ],
//           ),

//           const SizedBox(width: 10),

//           // CANCEL STATUS
//           Text(
//             order.status,
//             style: TextStyle(
//               color: order.status.toLowerCase() == "canceled"
//                   ? Colors.red
//                   : Colors.green,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return "${date.day} ${_month(date.month)} ${date.year}";
//   }

//  String _formatTime(String? time) {
//   if (time == null || time.isEmpty) {
//     return "---"; // or return ""; anything safe
//   }

//   try {
//     final date = DateTime.parse(time).toLocal();
//     return DateFormat.jm().format(date);
//   } catch (e) {
//     return "---";
//   }
// }


//   String _month(int m) {
//     const months = [
//       "Jan","Feb","Mar","Apr","May","Jun",
//       "Jul","Aug","Sep","Oct","Nov","Dec"
//     ];
//     return months[m - 1];
//   }
// }
