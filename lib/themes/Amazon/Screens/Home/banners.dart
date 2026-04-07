
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/api/banners/bannersApi.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Banners/banner.dart';




class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final AmzVendorController vendorController =
  Get.find<AmzVendorController>();

  final CarouselSliderController _carouselController =
  CarouselSliderController();

  late Worker _vendorWorker;

  BannerListResponse? bannerData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      fetchBannerList(vendorId);
    }

    _vendorWorker = ever<String>(
      vendorController.vendorId,
          (vendorId) {
        if (vendorId.isNotEmpty) {
          fetchBannerList(vendorId);
        }
      },
    );
  }

  Future<void> fetchBannerList(String vendorId) async {
    setState(() => isLoading = true);

    try {
      final api = AmzBannerApiService();
      final result = await api.getBannerList(vendorId);

      if (!mounted) return;

      setState(() {
        bannerData = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _vendorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _shimmerBanner();
    }

    if (bannerData == null || bannerData!.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return _bannerOnlyUI();
  }

  /// 🔹 Banner Only UI
  Widget _bannerOnlyUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: bannerData!.banners.length,
        itemBuilder: (context, index, realIndex) {
          final banner = bannerData!.banners[index];

          final imgUrl = banner.images.isNotEmpty
              ? banner.images.first.image
              : banner.bannerUrl;

          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imgUrl,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image),
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 400,
          autoPlay: false,
          autoPlayInterval: const Duration(seconds: 8),
          viewportFraction: .95,
          enableInfiniteScroll: false,
          scrollPhysics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }

  /// 🔹 Shimmer Placeholder
  Widget _shimmerBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// class BannerScreen extends StatefulWidget {
//   const BannerScreen({super.key});
//
//   @override
//   State<BannerScreen> createState() => _BannerScreenState();
// }
//
// class _BannerScreenState extends State<BannerScreen> {
//   // ✅ SAFELY initialized controller
//   final NexusVendorController vendorController =
//   Get.find<NexusVendorController>();
//
//   final CarouselSliderController _carouselController =
//   CarouselSliderController();
//
//   late Worker _vendorWorker;
//
//   int activeIndex = 0;
//   BannerListResponse? bannerData;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 🔹 Load banner immediately if vendorId already exists
//     final vendorId = vendorController.vendorId.value;
//     if (vendorId.isNotEmpty) {
//       fetchBannerList(vendorId);
//     }
//
//     // 🔥 Listen for vendorId changes
//     _vendorWorker = ever<String>(
//       vendorController.vendorId,
//           (vendorId) {
//         if (vendorId.isNotEmpty) {
//           debugPrint("✅ Vendor ID received in BannerScreen: $vendorId");
//           fetchBannerList(vendorId);
//         }
//       },
//     );
//   }
//
//   Future<void> fetchBannerList(String vendorId) async {
//     setState(() => isLoading = true);
//
//     try {
//       final api = AmzBannerApiService();
//       final result = await api.getBannerList(vendorId);
//
//       if (!mounted) return;
//
//       setState(() {
//         bannerData = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("❌ Banner API Error: $e");
//       if (!mounted) return;
//
//       setState(() {
//         bannerData = null;
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     // ✅ Prevent memory leak
//     _vendorWorker.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return  Center(child:  Shimmer.fromColors(
//         baseColor: Colors.grey.shade300,
//         highlightColor: Colors.grey.shade100,
//         child: Container(
//           width: 120,
//           height: 20,
//           color: Colors.white,
//         ),
//       ),);
//     }
//
//     if (bannerData == null || bannerData!.banners.isEmpty) {
//       return const Center(child: Text("No banners found"));
//     }
//
//     return _buildBannerUI();
//   }
//
//   Widget _buildBannerUI() {
//     return Column(
//       children: [
//         CarouselSlider.builder(
//           carouselController: _carouselController,
//           itemCount: bannerData!.banners.length,
//           itemBuilder: (context, index, realIndex) {
//             final banner = bannerData!.banners[index];
//
//             final imgUrl = banner.images.isNotEmpty
//                 ? banner.images.first.image
//                 : banner.bannerUrl;
//
//             return ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 imgUrl,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 loadingBuilder: (context, child, progress) {
//                   if (progress == null) return child;
//                   return const Center(
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) =>
//                 const Icon(Icons.broken_image),
//               ),
//             );
//           },
//           options: CarouselOptions(
//             height: 180,
//             autoPlay: true,
//             enlargeCenterPage: true,
//             viewportFraction: 0.9,
//             onPageChanged: (index, reason) {
//               setState(() => activeIndex = index);
//             },
//           ),
//         ),
//
//         const SizedBox(height: 10),
//
//         AnimatedSmoothIndicator(
//           activeIndex: activeIndex,
//           count: bannerData!.banners.length,
//           effect: const ExpandingDotsEffect(
//             dotHeight: 8,
//             dotWidth: 8,
//             expansionFactor: 3,
//           ),
//         ),
//       ],
//     );
//   }
// }
