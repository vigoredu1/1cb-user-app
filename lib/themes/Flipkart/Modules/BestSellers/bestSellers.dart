import 'dart:convert';


/// =======================
/// ROOT RESPONSE
/// =======================
class BestSellerResponse {
  final Meta? meta;
  final dynamic error;
  final List<BestSellerData> data;

  BestSellerResponse({
    this.meta,
    this.error,
    required this.data,
  });

  factory BestSellerResponse.fromJson(Map<String, dynamic> json) {
    return BestSellerResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
      data: (json['data'] as List?)
              ?.map((e) => BestSellerData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// =======================
/// META
/// =======================
class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      paginationInfo: json['paginationInfo'],
    );
  }
}

/// =======================
/// DATA ITEM
/// =======================
class BestSellerData {
  final Product? product;
  final List<ShippingDetails> shippingDetails;
  final WholesalerAddress? wholesalerAddress;
final ResalerAddress? resalerAddress;


  BestSellerData({
    this.product,
    required this.shippingDetails,
    required this.wholesalerAddress,
    required this.resalerAddress,
  });

  factory BestSellerData.fromJson(Map<String, dynamic> json) {
    return BestSellerData(
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      shippingDetails: (json['shipping_details'] as List?)
              ?.map((e) => ShippingDetails.fromJson(e))
              .toList() ??
          [],
      wholesalerAddress: json['wholesalerAddress'] != null
    ? WholesalerAddress.fromJson(json['wholesalerAddress'])
    : null,

      resalerAddress: json['resalerAddress'] != null
    ? ResalerAddress.fromJson(json['resalerAddress'])
    : null,

    );
  }
}

/// =======================
/// PRODUCT
/// =======================
class Product {
  final String id;
  final String vendorId;
  final String title;
  final String sku;
  final String productType;
  final String description;
  final String productImage;

  final double price;
  final double costPrice;
  final double salePrice;

  final String inventoryStatus;
  final String availability;
  final String brand;
  final String totalQuantity;
  final String categoryName;

  final List<ProductImage> images;

  Product({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.sku,
    required this.productType,
    required this.description,
    required this.productImage,
    required this.price,
    required this.costPrice,
    required this.salePrice,
    required this.inventoryStatus,
    required this.availability,
    required this.brand,
    required this.totalQuantity,
    required this.categoryName,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      productType: json['product_type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      productImage: json['product_image']?.toString() ?? '',

      price: _toDouble(json['price']),
      costPrice: _toDouble(json['cost_price']),
      salePrice: _toDouble(json['sale_price']),

      inventoryStatus: json['inventory_status']?.toString() ?? '',
      availability: json['availability']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      totalQuantity: json['totalQuantity']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',

      images: (json['images'] as List?)
              ?.map((e) => ProductImage.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// =======================
/// PRODUCT IMAGE
/// =======================
class ProductImage {
  final String id;
  final String productId;
  final String image;
  final List<String> colors;
  final List<SizeModel> sizes;

  ProductImage({
    required this.id,
    required this.productId,
    required this.image,
    required this.colors,
    required this.sizes,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      colors: (json['colors'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sizes: (json['sizes'] as List?)
              ?.map((e) => SizeModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// =======================
/// SIZE MODEL
/// =======================
class SizeModel {
  final String stock;
  final String price;
  final String size;

  SizeModel({
    required this.stock,
    required this.price,
    required this.size,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      stock: json['stock']?.toString() ?? '0',
      price: json['price']?.toString() ?? '0',
      size: json['Size']?.toString() ?? '',
    );
  }
}

/// =======================
/// SHIPPING DETAILS
/// =======================
class ShippingDetails {
  final String locationName;
  final String shippingCharge;

  ShippingDetails({
    required this.locationName,
    required this.shippingCharge,
  });

  factory ShippingDetails.fromJson(Map<String, dynamic> json) {
    return ShippingDetails(
      locationName: json['location_name']?.toString() ?? '',
      shippingCharge: json['shipping_charge']?.toString() ?? '0',
    );
  }
}

/// =======================
/// WHOLESALER ADDRESS
/// =======================
class WholesalerAddress {
  final String userId;
  final String originCountry;
  final String originState;
  final String originCity;
  final String originPostalCode;

  WholesalerAddress({
    required this.userId,
    required this.originCountry,
    required this.originState,
    required this.originCity,
    required this.originPostalCode,
  });

  factory WholesalerAddress.fromJson(Map<String, dynamic> json) {
    return WholesalerAddress(
      userId: json['userId']?.toString() ?? '',
      originCountry: _decodeList(json['originCountry']),
      originState: _decodeList(json['originState']),
      originCity: _decodeList(json['originCity']),
      originPostalCode: _decodeList(json['originPostalCode']),
    );
  }
}

/// =======================
/// RESALER ADDRESS
/// =======================
class ResalerAddress {
  final String id;
  final dynamic country;

  ResalerAddress({
    required this.id,
    this.country,
  });

  factory ResalerAddress.fromJson(Map<String, dynamic> json) {
    return ResalerAddress(
      id: json['id']?.toString() ?? '',
      country: json['country'],
    );
  }
}

/// =======================
/// HELPERS
/// =======================
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  return double.tryParse(value.toString()) ?? 0.0;
}

String _decodeList(dynamic value) {
  try {
    if (value == null) return '';
    final list = jsonDecode(value);
    return (list as List).isNotEmpty ? list.first.toString() : '';
  } catch (_) {
    return '';
  }
}
