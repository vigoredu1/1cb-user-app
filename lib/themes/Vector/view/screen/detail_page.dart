// import 'package:flutter/material.dart';
// import 'package:one_click_builder/themes/Vector/view/screen/product_detail_screen.dart';
// import 'package:one_click_builder/themes/Vector/widget/common_button.dart';
// import 'package:provider/provider.dart';
//
// import '../../controller/subcategory_product_provider.dart';
// import '../../data/model/home/product_model.dart';
//
// class CategoryDetailPage extends StatefulWidget {
//   final String subCategoryId; // The subcategory id passed from AppDrawer
//
//   const CategoryDetailPage({
//     Key? key,
//     required this.subCategoryId,
//   }) : super(key: key);
//
//   @override
//   _CategoryDetailPageState createState() => _CategoryDetailPageState();
// }
//
// class _CategoryDetailPageState extends State<CategoryDetailPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Ensure that products are loaded. If not, load them and then filter.
//
//     Future.delayed(Duration.zero, () async {
//       final provider =
//           Provider.of<SubCategoryProjectProvider>(context, listen: false);
//       if (provider.allProducts.isEmpty) {
//         await provider.loadAllProducts();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Products"),
//       ),
//       body: Consumer<SubCategoryProjectProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (provider.errorMessage != null) {
//             return Center(child: Text(provider.errorMessage!));
//           } else {
//             // Filter products by subCategoryId.
//             // List<Product> filteredProducts =
//             //     // provider.getProductsBySubcategory(widget.subCategoryId).cast<Product>();
//             // if (filteredProducts.isEmpty) {
//             //   return const Center(
//             //       child: Text("No products available for this subcategory."));
//             // }
//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 int crossAxisCount = _getCrossAxisCount(context);
//                 return GridView.builder(
//                  padding: const EdgeInsets.all(10),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: crossAxisCount,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 0.6,
//                   ),
//                   itemCount: filteredProducts.length,
//                   itemBuilder: (context, index) {
//                     Product product = filteredProducts[index];
//                     return Card(
//                       color: Colors.white,
//                       elevation: 2,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Center(
//                               child: Image.network(
//                                 product.images[0],
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Image.network(
//                                     'https://img.freepik.com/free-vector/hand-drawn-no-data-illustration_23-2150544943.jpg',
//                                     height: 150,
//                                     width: 150,
//                                     fit: BoxFit.cover,
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               product.title,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "₹${product.price}",
//                               style: const TextStyle(
//                                   fontSize: 14, color: Colors.green),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 10),
//                             CommonButton(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => ProductDetailScreen(
//                                           productId: product.id,
//                                           description: product.description,
//                                           images: product.images[0],
//                                           price: product.price,
//                                           brandname: product.brandName,
//                                           title: product.title),
//                                     ),
//                                   );
//                                 },
//                                 buttonText: "Buy Now")
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   int _getCrossAxisCount(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     if (width >= 1200) {
//       return 4;
//     } else if (width >= 800) {
//       return 3;
//     } else if (width >= 600) {
//       return 2;
//     } else {
//       return 2;
//     }
//   }
// }
