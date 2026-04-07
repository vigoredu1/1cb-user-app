// import 'package:flutter/foundation.dart';

class BannerModel {
  Meta? meta;
  dynamic error;
  Data? data;

  BannerModel({this.meta, this.error, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (meta != null) map['meta'] = meta!.toJson();
    map['error'] = error;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class Meta {
  dynamic paginationInfo;

  Meta({this.paginationInfo});

  Meta.fromJson(Map<String, dynamic> json) {
    paginationInfo = json['paginationInfo'];
  }

  Map<String, dynamic> toJson() {
    return {'paginationInfo': paginationInfo};
  }
}

class Data {
  List<BannerItem>? banners;

  Data({this.banners});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = List<BannerItem>.from(
        json['banners'].map((e) => BannerItem.fromJson(e)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'banners': banners?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class BannerItem {
  String? bannerId;
  String? vendorId;
  String? product;
  String? productName;
  String? categoryName;
  String? bannerType;
  String? resourceType;
  String? bannerUrl;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<BannerImage>? images;

  BannerItem({
    this.bannerId,
    this.vendorId,
    this.product,
    this.productName,
    this.categoryName,
    this.bannerType,
    this.resourceType,
    this.bannerUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.images,
  });

  BannerItem.fromJson(Map<String, dynamic> json) {
    bannerId = json['bannerId'];
    vendorId = json['vendorId'];
    product = json['product'];
    productName = json['productName'];
    categoryName = json['categoryName'];
    bannerType = json['bannerType'];
    resourceType = json['resourceType'];
    bannerUrl = json['bannerUrl'];
    status = json['status'];
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
    if (json['images'] != null) {
      images = List<BannerImage>.from(
          json['images'].map((e) => BannerImage.fromJson(e)));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerId': bannerId ?? '',
      'vendorId': vendorId ?? '',
      'product': product ?? '',
      'productName': productName ?? '',
      'categoryName': categoryName ?? '',
      'bannerType': bannerType ?? '',
      'resourceType': resourceType ?? '',
      'bannerUrl': bannerUrl ?? '',
      'status': status ?? 0,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'images': images?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}

class BannerImage {
  String? id;
  String? title;
  String? description;
  String? image;

  BannerImage({this.id, this.title, this.description, this.image});

  BannerImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    // if (kDebugMode) {
    //   print("id");
    // }
    // print(id);
    // print("image");
    // print(image);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '',
      'title': title ?? '',
      'description': description ?? '',
      'image': image ?? '',
    };
  }}
