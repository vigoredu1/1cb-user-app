// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
// import 'package:one_click_builder/themes/Flipkart/Modules/Categories/category.dart';
// import 'package:one_click_builder/themes/Flipkart/api/Categoryalist/categoryList.dart';

// import 'package:shimmer/shimmer.dart';

// class AllCategoriesScreen extends StatefulWidget {
//   const AllCategoriesScreen({super.key});

//   @override
//   State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
// }

// class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
//   final FlipkartCategoryApiService apiService = FlipkartCategoryApiService();
//     final FlipkartVendorController vendorController =
//       Get.find<FlipkartVendorController>();
//   FlipkartCategoryResponse? categoryResponse;
//   bool loading = true;

//   late Worker _vendorWorker;

// @override
// void initState() {
//   super.initState();

//   // ✅ Call immediately if vendor already exists
//   final vendorId = vendorController.vendorId.value;
//   if (vendorId.isNotEmpty) {
//     loadCategories(vendorId);
//   }

//   // ✅ Listen for future vendor changes
//   _vendorWorker = ever<String>(
//     vendorController.vendorId,
//     (vendorId) {
//       if (vendorId.isNotEmpty) {
//         loadCategories(vendorId);
//       }
//     },
//   );
// }


// Future<void> loadCategories(String vendorId) async {
//   setState(() => loading = true);

//   try {
//     categoryResponse = await apiService.fetchCategories(vendorId);
//   } catch (e) {
//     debugPrint("AllCategories API error: $e");
//   }

//   if (!mounted) return;
//   setState(() => loading = false);
// }


// @override
// void dispose() {
//   _vendorWorker.dispose();
//   super.dispose();
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF6F6F6),

//       /// 🔥 APP BAR (MATCH IMAGE)
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           "Categories",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),

//       body: loading
//           ?  Center(child:  Shimmer.fromColors(
//     baseColor: Colors.grey.shade300,
//     highlightColor: Colors.grey.shade100,
//     child: Container(
//       width: 120,
//       height: 20,
//       color: Colors.white,
//     ),
//   ),)
//           : _buildCategoryList(),
//     );
//   }

//   Widget _buildCategoryList() {
//     final categories = categoryResponse?.data?.categories ?? [];

//     if (categories.isEmpty) {
//       return const Center(child: Text("No categories found"));
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final item = categories[index];

//         return GestureDetector(
//           onTap: () {
//             final vendorController = Get.find<FlipkartVendorController>();
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => AllSubCategory(
//                   subcategoryId: vendorController.vendorId.value,
//                   subcategoryName: item.name.toString(),
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 14),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Row(
//               children: [
//                 /// 🔥 IMAGE (LEFT)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   child: Image.network(
//                     item.imageUrl ?? "",
//                     height: 70,
//                     width: 70,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) =>
//                         const Icon(Icons.image, size: 40),
//                   ),
//                 ),

//                 const SizedBox(width: 16),

//                 /// 🔥 TEXT (RIGHT)
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.name ?? "",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         item.description ??
//                             "Brands, Clothing, Footwear",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
