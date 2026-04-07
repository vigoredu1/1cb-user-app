class WishlistResponse {
  final Meta? meta;
  final dynamic error;
  final WishlistData? data;

  WishlistResponse({
    this.meta,
    this.error,
    this.data,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
      data: json['data'] != null ? WishlistData.fromJson(json['data']) : null,
    );
  }
}
class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      paginationInfo: json['paginationInfo'],
    );
  }
}
class WishlistData {
  final String wishlistId;
  final String userId;
  final int totalItem;
  final List<Product> products;

  WishlistData({
    required this.wishlistId,
    required this.userId,
    required this.totalItem,
    required this.products,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      wishlistId: json['wishlistId'] ?? "",
      userId: json['userId'] ?? "",
      totalItem: json['totalItem'] ?? 0,
      products: (json['products'] as List? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
class Product {
  final String id;
  final String vendorId;
  final String title;
  final String sku;
  final String productType;
  final String categoryId;
  final String description;
  final String? productImage;
  final int price;
  final int costPrice;
  final int salePrice;
  final String taxesAndCharges;
  final String unit;
  final dynamic retailPrice;
  final String inventoryStatus;
  final String availability;
  final String globalTradeItemNumber;
  final dynamic manufacturerPartNumber;
  final String brandName;
  final dynamic productUpcEan;
  final int isShippingFree;
  final dynamic pageTitle;
  final dynamic metaKeywords;
  final dynamic metaDescription;
  final dynamic productUrl;
  final String deliveryEventName;
  final dynamic deliveryFromDate;
  final dynamic deliveryToDate;
  final String createdAt;
  final String updatedAt;
  final dynamic subCategory;
  final String categoryName;
  final dynamic subCategoryName;
  final String taxOptions;
  final int isImported;
  final String internationalShippingPrice;
  final String currency;
  final dynamic videos;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.sku,
    required this.productType,
    required this.categoryId,
    required this.description,
    this.productImage,
    required this.price,
    required this.costPrice,
    required this.salePrice,
    required this.taxesAndCharges,
    required this.unit,
    this.retailPrice,
    required this.inventoryStatus,
    required this.availability,
    required this.globalTradeItemNumber,
    this.manufacturerPartNumber,
    required this.brandName,
    this.productUpcEan,
    required this.isShippingFree,
    this.pageTitle,
    this.metaKeywords,
    this.metaDescription,
    this.productUrl,
    required this.deliveryEventName,
    this.deliveryFromDate,
    this.deliveryToDate,
    required this.createdAt,
    required this.updatedAt,
    this.subCategory,
    required this.categoryName,
    this.subCategoryName,
    required this.taxOptions,
    required this.isImported,
    required this.internationalShippingPrice,
    required this.currency,
    this.videos,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? "",
      vendorId: json['vendor_id'] ?? "",
      title: json['title'] ?? "",
      sku: json['sku'] ?? "",
      productType: json['product_type'] ?? "",
      categoryId: json['category_id'] ?? "",
      description: json['description'] ?? "",
      productImage: json['product_image'],
      price: json['price'] ?? 0,
      costPrice: json['cost_price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      taxesAndCharges: json['taxesAndCharges'] ?? "",
      unit: json['unit'] ?? "",
      retailPrice: json['retail_price'],
      inventoryStatus: json['inventory_status'] ?? "",
      availability: json['availability'] ?? "",
      globalTradeItemNumber: json['global_trade_item_number'] ?? "",
      manufacturerPartNumber: json['manufacturer_part_number'],
      brandName: json['brand_name'] ?? "",
      productUpcEan: json['product_upc_ean'],
      isShippingFree: json['is_shipping_free'] ?? 0,
      pageTitle: json['page_title'],
      metaKeywords: json['meta_keywords'],
      metaDescription: json['meta_description'],
      productUrl: json['product_url'],
      deliveryEventName: json['delivery_event_name'] ?? "",
      deliveryFromDate: json['delivery_from_date'],
      deliveryToDate: json['delivery_to_date'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      subCategory: json['subCategory'],
      categoryName: json['categoryName'] ?? "",
      subCategoryName: json['subCategoryName'],
      taxOptions: json['taxOptions'] ?? "",
      isImported: json['Isimported'] ?? 0,
      internationalShippingPrice: json['internationalshippingPrice'] ?? "",
      currency: json['currency'] ?? "",
      videos: json['videos'],
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
    );
  }
}
class ProductImage {
  final String id;
  final String image;
  final String colors;
  final String sizes;
  final String stock;
  final String price;
  final String createdAt;
  final String updatedAt;

  ProductImage({
    required this.id,
    required this.image,
    required this.colors,
    required this.sizes,
    required this.stock,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? "",
      image: json['image'] ?? "",
      colors: json['colors'] ?? "",
      sizes: json['sizes'] ?? "",
      stock: json['stock'] ?? "",
      price: json['price'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }
}