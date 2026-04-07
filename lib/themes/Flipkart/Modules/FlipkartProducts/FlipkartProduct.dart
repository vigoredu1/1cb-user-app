import 'dart:convert';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

/* -----------------------------------------------------------
                    MAIN RESPONSE
--------------------------------------------------------------*/

class ProductListResponse {
  final List<ProductData> products;

  ProductListResponse({required this.products});

factory ProductListResponse.fromJson(Map<String, dynamic> json) {
  final data = json["data"];

  if (data is Map && data["product"] is List) {
    return ProductListResponse(
      products: (data["product"] as List)
          .map((e) => ProductData.fromJson(e))
          .toList(),
    );
  }

  if (data is Map && data["products"] is List) {
    return ProductListResponse(
      products: (data["products"] as List)
          .map((e) => ProductData.fromJson(e))
          .toList(),
    );
  }

  if (data is List) {
    return ProductListResponse(
      products: data.map((e) => ProductData.fromJson(e)).toList(),
    );
  }

  return ProductListResponse(products: []);
}

}

/* -----------------------------------------------------------
                    PRODUCT DATA
--------------------------------------------------------------*/

class ProductData {
  final Product? product;
  final List<ShippingDetail> shippingDetails;
  final List<dynamic> reviews;
  final List<WholesalerAddress> wholesalerAddress;
  final ResalerAddress? resalerAddress;

  ProductData({
    required this.product,
    required this.shippingDetails,
    required this.reviews,
    required this.wholesalerAddress,
    required this.resalerAddress,
  });

factory ProductData.fromJson(Map<String, dynamic> json) {
  List safeList(dynamic value) {
    if (value is List) return value;
    return [];
  }

  return ProductData(
    product:
        json["product"] == null ? null : Product.fromJson(json["product"]),

    shippingDetails: safeList(json["shipping_details"])
        .map((e) => ShippingDetail.fromJson(e))
        .toList(),

    reviews: safeList(json["reviews"]),

    wholesalerAddress: safeList(json["wholesalerAddress"])
        .map((e) => WholesalerAddress.fromJson(e))
        .toList(),

    resalerAddress: json["resalerAddress"] == null
        ? null
        : ResalerAddress.fromJson(json["resalerAddress"]),
  );
}

}

/* -----------------------------------------------------------
                    PRODUCT MODEL
--------------------------------------------------------------*/

class Product {
  final String id;
  final String vendorId;
  final String title;
  final String sku;
  final String productType;
  final String description;
  final double price;
  final double costPrice;
  final double salePrice;
  final String inventoryStatus;
  final String availability;
  final String categoryName;
  final double mrpPrice;
  final double discountPrice;
  final int currentStock;
  final List<ProductImage> images;

  Product({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.sku,
    required this.productType,
    required this.description,
    required this.price,
    required this.costPrice,
    required this.salePrice,
    required this.inventoryStatus,
    required this.availability,
    required this.categoryName,
    required this.mrpPrice,
    required this.discountPrice,
    required this.currentStock,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) =>
        double.tryParse(v?.toString() ?? "") ?? 0;

    int toInt(dynamic v) => int.tryParse(v?.toString() ?? "") ?? 0;

    return Product(
      id: json["id"]?.toString() ?? "",
      vendorId: json["vendor_id"]?.toString() ?? "",
      title: (json["productName"] ?? json["title"])?.toString() ?? "",
      sku: json["sku"]?.toString() ?? "",
      productType: json["product_type"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      price: toDouble(json["price"]),
      costPrice: toDouble(json["cost_price"]),
      salePrice: toDouble(json["sale_price"]),
      inventoryStatus: json["inventory_status"]?.toString() ?? "",
      availability: json["availability"]?.toString() ?? "",
      categoryName: json["categoryName"]?.toString() ?? "",
      mrpPrice: toDouble(json["mrpPrice"]),
      discountPrice: toDouble(json["discountPrice"]),
      currentStock: toInt(json["currentStock"]),
      images: (json["images"] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
    );
  }
}

/* -----------------------------------------------------------
                PRODUCT IMAGES + SIZES
--------------------------------------------------------------*/

class ProductImage {
  final String id;
  final String image;
  final List<ImageSize> sizes;
  final List<String> colors;

  ProductImage({
    required this.id,
    required this.image,
    required this.sizes,
    required this.colors,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json["id"]?.toString() ?? "",
        image: json["image"]?.toString() ?? "",
        sizes: (json["sizes"] as List? ?? [])
            .map((e) => ImageSize.fromJson(e))
            .toList(),
        colors: (json["colors"] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
      );
}

class ImageSize {
  final String stock;
  final String price;
  final String size;

  ImageSize({
    required this.stock,
    required this.price,
    required this.size,
  });

  factory ImageSize.fromJson(Map<String, dynamic> json) => ImageSize(
        stock: json["stock"]?.toString() ?? "0",
        price: json["price"]?.toString() ?? "0",
        size: json["size"]?.toString() ?? "",
      );
}

/* -----------------------------------------------------------
                SHIPPING DETAILS
--------------------------------------------------------------*/

class ShippingDetail {
  final String productId;
  final String locationName;
  final String shippingCharge;

  ShippingDetail({
    required this.productId,
    required this.locationName,
    required this.shippingCharge,
  });

  factory ShippingDetail.fromJson(Map<String, dynamic> json) =>
      ShippingDetail(
        productId: json["product_id"]?.toString() ?? "",
        locationName: json["location_name"]?.toString() ?? "",
        shippingCharge: json["shipping_charge"]?.toString() ?? "0",
      );
}

/* -----------------------------------------------------------
                WHOLESALER ADDRESS
--------------------------------------------------------------*/

class WholesalerAddress {
  final String userId;
  final List<String> originCountry;
  final List<String> originState;
  final List<String> originCity;
  final List<String> originPostalCode;

  WholesalerAddress({
    required this.userId,
    required this.originCountry,
    required this.originState,
    required this.originCity,
    required this.originPostalCode,
  });

  factory WholesalerAddress.fromJson(Map<String, dynamic> json) {
    List<String> parse(dynamic value) {
      try {
        if (value == null) return [];
        if (value is List) return value.map((e) => e.toString()).toList();
        if (value is String && value.trim().startsWith("[")) {
          return List<String>.from(jsonDecode(value));
        }
        if (value is String) return [value];
        return [];
      } catch (_) {
        return [];
      }
    }

    return WholesalerAddress(
      userId: json["userId"]?.toString() ?? "",
      originCountry: parse(json["originCountry"]),
      originState: parse(json["originState"]),
      originCity: parse(json["originCity"]),
      originPostalCode: parse(json["originPostalCode"]),
    );
  }
}

/* -----------------------------------------------------------
                RESALER ADDRESS
--------------------------------------------------------------*/

class ResalerAddress {
  final String id;
  final String? country;

  ResalerAddress({
    required this.id,
    required this.country,
  });

  factory ResalerAddress.fromJson(Map<String, dynamic> json) =>
      ResalerAddress(
        id: json["id"]?.toString() ?? "",
        country: json["country"]?.toString(),
      );
}
