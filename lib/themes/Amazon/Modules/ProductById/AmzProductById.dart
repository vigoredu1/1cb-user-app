import 'dart:convert';

/// ---------- HELPERS ----------

num? toNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}

List<String> toStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  if (value is String) {
    return List<String>.from(jsonDecode(value));
  }
  return [];
}

List<T> toObjectList<T>(
  dynamic value,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (value == null) return [];
  final list = value is String ? jsonDecode(value) : value;
  if (list is List) {
    return list.map((e) => fromJson(e)).toList();
  }
  return [];
}

/// ---------- RESPONSE ----------

class ProductResponse {
  final Meta? meta;
  final dynamic error;
  final Data? data;

  ProductResponse({this.meta, this.error, this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(paginationInfo: json['paginationInfo']);
  }
}

/// ---------- DATA ----------

class Data {
  final Product? product;
  final List<ShippingDetails> shippingDetails;

  Data({this.product, required this.shippingDetails});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      shippingDetails: json['shipping_details'] != null
          ? List<ShippingDetails>.from(
              json['shipping_details']
                  .map((x) => ShippingDetails.fromJson(x)),
            )
          : [],
    );
  }
}

/// ---------- PRODUCT ----------

class Product {
  final String? id;
  final String? vendorId;
  final String? title;
  final String? sku;
  final String? productType;
  final String? categoryId;
  final String? description;
  final String? productImage;

  final num? price;
  final num? costPrice;
  final num? salePrice;
  final num? retailPrice;

  final String? inventoryStatus;
  final String? availability;

  final String? brandName;

  final int? isShippingFree;
  final int? isImported;

  final String? shippingPrice;
  final int? currentStock;
  final int? lowStock;

  final List<String> sizes;
  final List<String> colorImages;

  final int? peopleViewed;
  final num? packagingCharges;
  final int? isPackagingCharges;

  final int? status;
  final int? isFeaturedProduct;

  final String? currency;

  final List<ProductImage> images;
  final List<CustomFields> customFields;

  Product({
    this.id,
    this.vendorId,
    this.title,
    this.sku,
    this.productType,
    this.categoryId,
    this.description,
    this.productImage,
    this.price,
    this.costPrice,
    this.salePrice,
    this.retailPrice,
    this.inventoryStatus,
    this.availability,
    this.brandName,
    this.isShippingFree,
    this.isImported,
    this.shippingPrice,
    this.currentStock,
    this.lowStock,
    required this.sizes,
    required this.colorImages,
    this.peopleViewed,
    this.packagingCharges,
    this.isPackagingCharges,
    this.status,
    this.isFeaturedProduct,
    this.currency,
    required this.images,
    required this.customFields,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      vendorId: json['vendor_id'],
      title: json['title'],
      sku: json['sku'],
      productType: json['product_type'],
      categoryId: json['category_id'],
      description: json['description'],
      productImage: json['product_image'],

      price: toNum(json['price']),
      costPrice: toNum(json['cost_price']),
      salePrice: toNum(json['sale_price']),
      retailPrice: toNum(json['retail_price']),

      inventoryStatus: json['inventory_status'],
      availability: json['availability'],
      brandName: json['brand_name'],

      isShippingFree: json['is_shipping_free'],
      isImported: json['is_imported'],

      shippingPrice: json['shippingPrice'],
      currentStock: json['currentStock'],
      lowStock: json['lowStock'],

      sizes: toStringList(json['sizes']),
      colorImages: toStringList(json['color_images']),

      peopleViewed: json['people_viewed'],
      packagingCharges: toNum(json['packagingCharges']),
      isPackagingCharges: json['isPackagingCharges'],

      status: json['status'],
      isFeaturedProduct: json['isFeaturedProduct'],

      currency: json['currency'],

      images: toObjectList(
        json['images'],
        (e) => ProductImage.fromJson(e),
      ),

      customFields: toObjectList(
        json['customFields'],
        (e) => CustomFields.fromJson(e),
      ),
    );
  }
}

/// ---------- IMAGES ----------

class ProductImage {
  final String? id;
  final String? productId;
  final String? image;
  final List<String> colors;
  final List<ProductSize> sizes;

  ProductImage({
    this.id,
    this.productId,
    this.image,
    required this.colors,
    required this.sizes,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['productId'],
      image: json['image'],
      colors: json['colors'] != null
          ? List<String>.from(jsonDecode(json['colors']))
          : [],
      sizes: json['sizes'] != null
          ? (jsonDecode(json['sizes']) as List)
              .map((e) => ProductSize.fromJson(e))
              .toList()
          : [],
    );
  }
}

/// ---------- SIZE ----------

class ProductSize {
  final String? stock;
  final num? price;
  final String? size;

  ProductSize({this.stock, this.price, this.size});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      stock: json['stock']?.toString(),
      price: toNum(json['price']),
      size: json['size'] ?? json['Size'],
    );
  }
}

/// ---------- CUSTOM FIELDS ----------

class CustomFields {
  final String? label;
  final String? value;

  CustomFields({this.label, this.value});

  factory CustomFields.fromJson(Map<String, dynamic> json) {
    return CustomFields(
      label: json['label'],
      value: json['value'],
    );
  }
}

/// ---------- SHIPPING ----------

class ShippingDetails {
  final String? locationName;
  final String? shippingCharge;

  ShippingDetails({this.locationName, this.shippingCharge});

  factory ShippingDetails.fromJson(Map<String, dynamic> json) {
    return ShippingDetails(
      locationName: json['location_name'],
      shippingCharge: json['shipping_charge'],
    );
  }
}
