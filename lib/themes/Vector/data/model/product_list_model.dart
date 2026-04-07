
class ProductList {
  final String id;
  final String vendorId;
  final String title;
  final String sku;
  final String productType;
  final String categoryId;
  final String description;
  final String? productImage;
  final double price;
  final double costPrice;
  final double salePrice;
  final double retailPrice;
  final String inventoryStatus;
  final String availability;
  final String? globalTradeItemNumber;
  final String? manufacturerPartNumber;
  final String brandName;
  final String? productUpcEan;
  final int isShippingFree;
  final String? pageTitle;
  final String? metaKeywords;
  final String? metaDescription;
  final String productUrl;
  final String deliveryEventName;
  final String? deliveryFromDate;
  final String? deliveryToDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String subCategory;
  final int isImported;
  final String? importedFromVendor;
  final String shippingPrice;
  final String? importedProductReference;
  final int currentStock;
  final int lowStock;
  final dynamic sizes;
  final dynamic colorImages;
  final int peopleViewed;
  final String about;
  final String taxesAndCharges;
  final dynamic unit;
  final dynamic taxOptions;
  final int packagingCharges;
  final int isPackagingCharges;
  final int status;
  final int isFeaturedProduct;
  final String categoryName;
  final String subCategoryName;
  final int totalReviews;
  final double rating;
  final String productName;
  final double sellingPrice;
  final String productId;
  final List<ExplorImage> images;
  final List<dynamic> tags;

  ProductList({
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
    required this.retailPrice,
    required this.inventoryStatus,
    required this.availability,
    this.globalTradeItemNumber,
    this.manufacturerPartNumber,
    required this.brandName,
    this.productUpcEan,
    required this.isShippingFree,
    this.pageTitle,
    this.metaKeywords,
    this.metaDescription,
    required this.productUrl,
    required this.deliveryEventName,
    this.deliveryFromDate,
    this.deliveryToDate,
    required this.createdAt,
    required this.updatedAt,
    required this.subCategory,
    required this.isImported,
    this.importedFromVendor,
    required this.shippingPrice,
    this.importedProductReference,
    required this.currentStock,
    required this.lowStock,
    this.sizes,
    this.colorImages,
    required this.peopleViewed,
    required this.about,
    required this.taxesAndCharges,
    this.unit,
    this.taxOptions,
    required this.packagingCharges,
    required this.isPackagingCharges,
    required this.status,
    required this.isFeaturedProduct,
    required this.categoryName,
    required this.subCategoryName,
    required this.totalReviews,
    required this.rating,
    required this.productName,
    required this.sellingPrice,
    required this.productId,
    required this.images,
    required this.tags,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return ProductList(
      id: product['id'] ?? '',
      vendorId: product['vendor_id'] ?? '',
      title: product['title'] ?? '',
      sku: product['sku'] ?? '',
      productType: product['product_type'] ?? '',
      categoryId: product['category_id'] ?? '',
      description: product['description'] ?? '',
      productImage: product['product_image'],
      price: (product['price'] ?? 0).toDouble(),
      costPrice: (product['cost_price'] ?? 0).toDouble(),
      salePrice: (product['sale_price'] ?? 0).toDouble(),
      retailPrice: (product['retail_price'] ?? 0).toDouble(),
      inventoryStatus: product['inventory_status'] ?? '',
      availability: product['availability'] ?? '',
      globalTradeItemNumber: product['global_trade_item_number'],
      manufacturerPartNumber: product['manufacturer_part_number'],
      brandName: product['brand_name'] ?? '',
      productUpcEan: product['product_upc_ean'],
      isShippingFree: product['is_shipping_free'] ?? 0,
      pageTitle: product['page_title'],
      metaKeywords: product['meta_keywords'],
      metaDescription: product['meta_description'],
      productUrl: product['product_url'] ?? '',
      deliveryEventName: product['delivery_event_name'] ?? '',
      deliveryFromDate: product['delivery_from_date'],
      deliveryToDate: product['delivery_to_date'],
      createdAt: DateTime.parse(product['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(product['updated_at'] ?? DateTime.now().toIso8601String()),
      subCategory: product['subCategory'] ?? '',
      isImported: product['is_imported'] ?? 0,
      importedFromVendor: product['imported_from_vendor'],
      shippingPrice: product['shippingPrice'] ?? '',
      importedProductReference: product['imported_product_reference'],
      currentStock: product['currentStock'] ?? 0,
      lowStock: product['lowStock'] ?? 0,
      sizes: product['sizes'],
      colorImages: product['color_images'],
      peopleViewed: product['people_viewed'] ?? 0,
      about: product['about'] ?? '',
      taxesAndCharges: product['taxesAndCharges'] ?? '',
      unit: product['unit'],
      taxOptions: product['taxOptions'],
      packagingCharges: product['packagingCharges'] ?? 0,
      isPackagingCharges: product['isPackagingCharges'] ?? 0,
      status: product['status'] ?? 0,
      isFeaturedProduct: product['isFeaturedProduct'] ?? 0,
      categoryName: product['categoryName'] ?? '',
      subCategoryName: product['subCategoryName'] ?? '',
      totalReviews: product['totalReviews'] ?? 0,
      rating: (product['rating'] ?? 0).toDouble(),
      productName: product['productName'] ?? '',
      sellingPrice: (product['sellingPrice'] ?? 0).toDouble(),
      productId: product['productId'] ?? '',
      images: product['images'] != null
          ? List<ExplorImage>.from(
          product['images'].map((x) => ExplorImage.fromJson(x)))
          : [],
      tags: product['tags'] ?? [],
    );
  }
}

class ExplorImage {
  final String? id;
  final String? productId;
  final String? image;
  final List<ImageSize>? sizes;

  ExplorImage({this.id, this.productId, this.image, this.sizes});

  factory ExplorImage.fromJson(Map<String, dynamic> json) {
    return ExplorImage(
      id: json['id'],
      productId: json['productId'] ?? json['product_id'],
      image: json['image'],
      sizes: json['sizes'] != null
          ? List<ImageSize>.from(
          json['sizes'].map((x) => ImageSize.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'image': image,
      'sizes': sizes?.map((x) => x.toJson()).toList(),
    };
  }
}

class ImageSize {
  final String? price;
  final String? stock;

  ImageSize({this.price, this.stock});

  factory ImageSize.fromJson(Map<String, dynamic> json) {
    return ImageSize(price: json['price'], stock: json['stock']);
  }

  Map<String, dynamic> toJson() {
    return {'price': price, 'stock': stock};
  }
}
