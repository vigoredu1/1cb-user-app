
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Banners/banner.dart';
import 'package:one_click_builder/themes/Flipkart/api/banners/bannersApi.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';



class FlipkartBannerScreen extends StatefulWidget {
  const FlipkartBannerScreen({super.key});

  @override
  State<FlipkartBannerScreen> createState() => _FlipkartBannerScreenState();
}

class _FlipkartBannerScreenState extends State<FlipkartBannerScreen> {
  // ✅ SAFELY initialized controller
  final FlipkartVendorController vendorController =
      Get.find<FlipkartVendorController>();

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late Worker _vendorWorker;

  int activeIndex = 0;
  BannerListResponse? bannerData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // 🔹 Load banner immediately if vendorId already exists
    final vendorId = vendorController.vendorId.value;
    if (vendorId.isNotEmpty) {
      fetchBannerList(vendorId);
    }

    // 🔥 Listen for vendorId changes
    _vendorWorker = ever<String>(
      vendorController.vendorId,
      (vendorId) {
        if (vendorId.isNotEmpty) {
          debugPrint("✅ Vendor ID received in FlipkartBannerScreen: $vendorId");
          fetchBannerList(vendorId);
        }
      },
    );
  }

  Future<void> fetchBannerList(String vendorId) async {
    setState(() => isLoading = true);

    try {
      final api = NexusBannerApiService();
      final result = await api.getBannerList(vendorId);

      if (!mounted) return;

      setState(() {
        bannerData = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Banner API Error: $e");
      if (!mounted) return;

      setState(() {
        bannerData = null;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // ✅ Prevent memory leak
    _vendorWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
    }

    if (bannerData == null || bannerData!.banners.isEmpty) {
      return const Center(child: Text("No banners found"));
    }

    return _buildBannerUI();
  }

  Widget _buildBannerUI() {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: bannerData!.banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = bannerData!.banners[index];

            final imgUrl = banner.images.isNotEmpty
                ? banner.images.first.image
                : banner.bannerUrl;

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image),
              ),
            );
          },
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() => activeIndex = index);
            },
          ),
        ),

        const SizedBox(height: 10),

        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: bannerData!.banners.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}
