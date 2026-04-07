class NexusCategoryResponse {
  final Meta? meta;
  final dynamic error;
  final CategoryData? data;

  NexusCategoryResponse({
    this.meta,
    this.error,
    this.data,
  });

  factory NexusCategoryResponse.fromJson(Map<String, dynamic> json) {
    return NexusCategoryResponse(
      meta: json["meta"] != null ? Meta.fromJson(json["meta"]) : null,
      error: json["error"],
      data: json["data"] != null ? CategoryData.fromJson(json["data"]) : null,
    );
  }
}

class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      paginationInfo: json["paginationInfo"],
    );
  }
}

class CategoryData {
  final List<Category>? categories;
  final List<Brand>? brands;
  final List<dynamic>? coupons;

  CategoryData({
    this.categories,
    this.brands,
    this.coupons,
  });

 factory CategoryData.fromJson(Map<String, dynamic> json) {
  return CategoryData(
    categories: (json["categories"] is List)
        ? (json["categories"] as List)
            .map((e) => Category.fromJson(e))
            .toList()
        : [],
    brands: (json["brands"] is List)
        ? (json["brands"] as List)
            .map((e) => Brand.fromJson(e))
            .toList()
        : [],
    coupons: json["coupons"] ?? [],
  );
}

}

class Category {
  final String? id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final List<Subcategory> subcategories;

  Category({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["image_url"],
      subcategories: (json["subcategories"] is List)
          ? (json["subcategories"] as List)
              .map((x) => Subcategory.fromJson(x))
              .toList()
          : [],
    );
  }
}


class Subcategory {
  final String? id;
  final String? name;

  Subcategory({this.id, this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Brand {
  final String? id;
  final String? vendorId;
  final String? name;
  final String? description;
  final String? imageUrl;

  Brand({
    this.id,
    this.vendorId,
    this.name,
    this.description,
    this.imageUrl,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json["id"],
      vendorId: json["vendor_id"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["image_url"],
    );
  }
}
