import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:shimmer/shimmer.dart';

import '../../../api/Categoryalist/categoryList.dart';
import '../../../Modules/Categories/category.dart';
import '../../Home/Category/allSubCategory/allSubCategory.dart';

class AmzCategoryScreen extends StatefulWidget {
  const AmzCategoryScreen({super.key});

  @override
  State<AmzCategoryScreen> createState() => _AmzCategoryScreenState();
}

class _AmzCategoryScreenState extends State<AmzCategoryScreen> {
  final AmzCategoryApiService apiService = AmzCategoryApiService();
  final AmzVendorController vendorController =
  Get.find<AmzVendorController>();

  AmzCategoryResponse? categoryResponse;
  List categories = [];
  bool loading = true;

  late Worker _vendorWorker;

  @override
  void initState() {
    super.initState();

    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      loadCategories(vendorId);
    }

    _vendorWorker = ever<String>(
      vendorController.vendorId,
          (vendorId) {
        if (vendorId.isNotEmpty) {
          loadCategories(vendorId);
        }
      },
    );
  }

  Future<void> loadCategories(String vendorId) async {
    setState(() => loading = true);

    try {
      final response = await apiService.fetchCategories(vendorId);
      if (!mounted) return;

      categories = response?.data?.categories ?? [];
      loading = false;
      setState(() {});
    } catch (e) {
      loading = false;
      setState(() {});
      debugPrint("❌ Category API error: $e");
    }
  }

  @override
  void dispose() {
    _vendorWorker.dispose();
    super.dispose();
  }

  String trimText(String text) {
    if (text.length <= 12) return text;
    return "${text.substring(0, 12)}...";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _shimmer();
    }

    if (categories.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text("No categories")),
      );
    }
  int columns = 6;
  int rows = (categories.length / columns).ceil();
  double itemHeight = 80;
  double gridHeight = rows * itemHeight;
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        "Top Categories",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    ),

    SizedBox(height: 10,),
        /// 🔥 HEADER
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         "All Categories",
        //         style: Theme.of(context).textTheme.titleLarge,
        //       ),
        //       GestureDetector(
        //         onTap: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (_) => const AllCategoriesScreen(),
        //             ),
        //           );
        //         },
        //         child: Text(
        //           "See all",
        //           style: TextStyle(
        //             fontSize: 13,
        //             fontWeight: FontWeight.w600,
        //             color: Theme.of(context).colorScheme.primary,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        /// 🔥 DOUBLE ROW CATEGORY GRID
        SizedBox(
  height: gridHeight,
  child: GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
      mainAxisSpacing: 18,
      crossAxisSpacing: 2,
      childAspectRatio: 0.75,
    ),
    itemCount: categories.length,
    itemBuilder: (context, index) {
      final item = categories[index];
      return _categoryCard(item);
    },
  ),
)


      ],
    );
  }

  /// 🔹 CATEGORY ITEM
Widget _categoryCard(dynamic item) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AllSubCategory(
            subcategoryId: vendorController.vendorId.value,
            subcategoryName: item.name.toString(),
          ),
        ),
      );
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
            image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(item.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: (item.imageUrl == null || item.imageUrl!.isEmpty)
              ? const Icon(Icons.category, size: 20)
              : null,
        ),

        const SizedBox(height: 4),

        /// FIX OVERFLOW
        Flexible(
          child: Text(
            trimText(item.name ?? ""),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

  /// 🔹 SHIMMER
  Widget _shimmer() {
    return SizedBox(
      height: 190,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 7,
            crossAxisSpacing: 14,
          ),
          itemCount: 8,
          itemBuilder: (_, __) {
            return Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 10,
                  width: 40,
                  color: Colors.white,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
