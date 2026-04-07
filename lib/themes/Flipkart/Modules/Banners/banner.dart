class BannerListResponse {
  final List<BannerItem> banners;

  BannerListResponse({required this.banners});

  factory BannerListResponse.fromJson(Map<String, dynamic> json) {
    final bannerData = json['data']?['banners'] as List<dynamic>? ?? [];
    return BannerListResponse(
      banners: bannerData.map((e) => BannerItem.fromJson(e)).toList(),
    );
  }
}

class BannerItem {
  final String bannerId;
  final String vendorId;
  final String? productName;
  final String? categoryName;
  final String bannerType;
  final String resourceType;
  final String bannerUrl;
  final List<BannerImage> images;

  BannerItem({
    required this.bannerId,
    required this.vendorId,
    this.productName,
    this.categoryName,
    required this.bannerType,
    required this.resourceType,
    required this.bannerUrl,
    required this.images,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    final imagesData = json['images'] as List<dynamic>? ?? [];
    return BannerItem(
      bannerId: json['bannerId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      productName: json['productName'],
      categoryName: json['categoryName'],
      bannerType: json['bannerType'] ?? '',
      resourceType: json['resourceType'] ?? '',
      bannerUrl: json['bannerUrl'] ?? '',
      images: imagesData.map((e) => BannerImage.fromJson(e)).toList(),
    );
  }
}

class BannerImage {
  final String id;
  final String title;
  final String description;
  final String image;

  BannerImage({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory BannerImage.fromJson(Map<String, dynamic> json) {
    return BannerImage(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
