import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/model/home/banner_model.dart';

class BannerUrlCard extends StatelessWidget {
  final BannerItem banner;

  const BannerUrlCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    // 🔹 Prefer image from banner.images
    String? imageUrl;

    if (banner.images != null && banner.images!.isNotEmpty) {
      imageUrl = banner.images!.first.image;
    } else if (banner.bannerUrl != null && banner.bannerUrl!.isNotEmpty) {
      imageUrl = banner.bannerUrl;
    }

    // 🔹 If no image at all, show nothing
    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, size: 60),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 160,
              width: double.infinity,
              color: Colors.grey.shade200,
              child:  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),),
            );
          },
        ),
      ),
    );
  }
}
