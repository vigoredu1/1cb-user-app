// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:svg_flutter/svg.dart';


// class NexusGlobalSearch extends StatefulWidget {
//   const NexusGlobalSearch({super.key});

//   @override
//   State<NexusGlobalSearch> createState() => _NexusGlobalSearchState();
// }

// class _NexusGlobalSearchState extends State<NexusGlobalSearch> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ProductListController>(context, listen: false).loadProducts();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Provider.of<ProductListController>(context);
//     final products = controller.products;

//     return Scaffold(
//       backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: SizedBox(
//                       height: 48,
//                       child: TextFormField(
//                         controller: controller.searchController,
//                         onChanged: controller.searchProduct,
//                         decoration: InputDecoration(
//                           fillColor: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
//                           filled: true,
//                           isDense: true,
//                           disabledBorder: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(6)),
//                               borderSide: BorderSide.none),
//                           focusedBorder: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(6)),
//                               borderSide: BorderSide.none),
//                           enabledBorder: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(6)),
//                               borderSide: BorderSide.none),
//                           border: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(6)),
//                               borderSide: BorderSide.none),
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                           prefixIcon: SvgPicture.asset(
//                             SvgAssets.iconSearch,
//                             fit: BoxFit.scaleDown,
//                           ),
//                           hintStyle: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14,
//                             color: AppTheme.fromType(AppTheme.defaultTheme)
//                                 .primaryColor
//                                 .withOpacity(0.34),
//                           ),
//                           hintText: 'Search Here',
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: () {
//                       // TODO: filter logic (open bottom sheet / new screen)
//                     },
//                     child: Container(
//                       height: 48,
//                       width: 48,
//                       decoration: BoxDecoration(
//                         color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
//                         borderRadius: const BorderRadius.all(Radius.circular(6)),
//                       ),
//                       child: Center(
//                         child: SvgPicture.asset(
//                           SvgAssets.iconFilter,
//                           fit: BoxFit.scaleDown,
//                           colorFilter: ColorFilter.mode(
//                             AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
//                             BlendMode.srcIn,
//                           ),
//                           height: 20,
//                           width: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // 🔄 Products List
//             Expanded(
//               child: controller.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : products.isEmpty
//                   ? const Center(child: Text("No products found."))
//                   : Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: GridView.builder(
//                   itemCount: products.length,
//                   padding: const EdgeInsets.only(top: 12),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 15,
//                     crossAxisSpacing: 15,
//                     childAspectRatio: 0.57,
//                   ),
//                   itemBuilder: (context, index) {
//                     final product = products[index];

//                     return Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: CupertinoColors.systemGrey4, width: 0.5),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Stack(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: product.productUrl.isNotEmpty
//                                     ? Image.network(
//                                   product.productUrl,
//                                   height: 200,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Image.asset(
//                                       Images.image,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                     );
//                                   },
//                                 )
//                                     : Image.asset(
//                                   Images.image,
//                                   height: 200,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               WishlistButton(
//                                 productId: product.id ?? '',
//                                 productImageId: product.images != null && product.images!.isNotEmpty
//                                     ? "${product.images![0].id}"
//                                     : "",
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             product.title ?? '',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 14),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             '₹ ${product.price ?? 0}',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
