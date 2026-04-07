import 'package:flutter/material.dart';
import '../../../data/model/home/banner_model.dart';

class AllBannerImagesList extends StatelessWidget {
  final List<BannerItem> banners;

  const AllBannerImagesList({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    final allImages = banners
        .expand((banner) => banner.images ?? [])
        .toList();

    final lastTwoImages = allImages.length >= 2
        ? allImages.sublist(allImages.length - 2)
        : allImages;

    if (lastTwoImages.isEmpty) return const SizedBox();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lastTwoImages.map((image) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image.image ?? '',
              width: MediaQuery.of(context).size.width *0.98,
              height: 180,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 40),
            ),
          ),
        );
      }).toList(),
    );
  }
}
