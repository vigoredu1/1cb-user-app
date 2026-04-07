import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:one_click_builder/themes/Nexus/Modules/Categories/category.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/Category/allCategories.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/Category/allSubCategory/allSubCategory.dart';
import 'package:one_click_builder/themes/Nexus/api/Categoryalist/categoryList.dart';
import 'package:shimmer/shimmer.dart' show Shimmer;

class NexusCategoryScreen extends StatefulWidget {
  const NexusCategoryScreen({super.key});

  @override
  State<NexusCategoryScreen> createState() => _NexusCategoryScreenState();
}

class _NexusCategoryScreenState extends State<NexusCategoryScreen> {
  final NexusCategoryApiService apiService = NexusCategoryApiService();
  NexusCategoryResponse? categoryResponse;

  bool loading = true;

  final int visibleCount = 6;
  List categories = [];
  List visibleItems = [];

  int currentIndex = 0;
  Timer? _timer;
  late Worker _vendorWorker;
  final vendorController = Get.find<NexusVendorController>();

  String trimTo8Words(String text) {
    final words = text.trim().split(RegExp(r"\s+"));

    // Always take only up to first 8 words
    final trimmed = words.take(5).join(" ");

    // Add "..." only if original text is longer than 8 words
    if (words.length > 8) {
      return "$trimmed...";
    }

    return trimmed; // always return trimmed version
  }

  @override
  void initState() {
    super.initState();

    // ✅ Call immediately if vendor already exists
    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      loadCategories(vendorId);
    }

    // ✅ Listen for future changes
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
    loading = true;
    setState(() {});

    try {
      final response = await apiService.fetchCategories(vendorId);

      if (!mounted) return;

      categories = response?.data?.categories ?? [];
      visibleItems.clear();

      if (categories.isNotEmpty) {
        visibleItems = categories.take(visibleCount).toList();
        currentIndex = visibleItems.length % categories.length;
        startAutoSlide();
      } else {
        visibleItems = List.from(categories);
      }

      loading = false;
      setState(() {});
    } catch (e) {
      loading = false;
      setState(() {});
      debugPrint("Category API error: $e");
    }
  }

  @override
  void dispose() {
    _vendorWorker.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startAutoSlide() {
    _timer?.cancel();

    if (categories.length < 2) return; // only stop if impossible to slide

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || visibleItems.isEmpty) return;

      setState(() {
        visibleItems.removeAt(0);
        visibleItems.add(categories[currentIndex]);
        currentIndex = (currentIndex + 1) % categories.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
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
    }

    if (visibleItems.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("No categories")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 HEADER (THEME DRIVEN)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Categories",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AllCategoriesScreen(),
                    ),
                  );
                },
                child: Text(
                  "See all",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),

        /// 🔥 AUTO SLIDING CATEGORY ROW
        SizedBox(
          height: 120,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 900),
            transitionBuilder: (child, animation) {
              final slide = Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(
                position: slide,
                child: child,
              );
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                key: ValueKey(visibleItems.map((e) => e.name).join("_")),
                children: visibleItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _categoryCard(item),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(dynamic item) {
    return GestureDetector(
      onTap: () {
        final vendorController = Get.find<NexusVendorController>();
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
        children: [
          // FIXED SIZE IMAGE BOX (NO BACKGROUND)
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
           //   color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              image: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(item.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (item.imageUrl == null || item.imageUrl!.isEmpty)
                ? const Icon(Icons.category, size: 28)
                : null,
          ),
          SizedBox(height: 4),
          SizedBox(
            width: 60, // reduced width to stop overflow
            child: Text(
              trimTo8Words(item.name ?? ""),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
