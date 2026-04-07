
/// ROOT RESPONSE
/// =======================================================
library;



/// ROOT RESPONSE
/// =======================================================
class OrderApiResponse {
  final Meta? meta;
  final dynamic error;
  final OrderData? data;

  OrderApiResponse({
    this.meta,
    this.error,
    this.data,
  });

  factory OrderApiResponse.fromJson(Map<String, dynamic> json) {

    final dynamic dataField = json['data'];

  // CASE 1 → data is a LIST → no orders
  if (dataField is List) {
    return OrderApiResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
      data: OrderData(
        message: json['error']?['message']?.toString() ?? "No orders found",
        orders: [],
      ),
    );
  }
    return OrderApiResponse(
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      error: json['error'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

/// =======================================================
/// META
/// =======================================================
class Meta {
  final dynamic paginationInfo;

  Meta({this.paginationInfo});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      paginationInfo: json['paginationInfo'],
    );
  }
}

/// =======================================================
/// DATA WRAPPER
/// =======================================================
class OrderData {
  final String message;
  final List<OrderModel> orders;

  OrderData({
    required this.message,
    required this.orders,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      message: json['message']?.toString() ?? '',
      orders: (json['orders'] as List? ?? [])
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }
}

/// =======================================================
/// ORDER MODEL
/// =======================================================
class OrderModel {
  final String id;
  final String vendorId;
  final String customerId;
  final String orderId;
  final int orderForwarded;
  final String name;
  final String email;
  final String avatar;
  final int items;
  final String price;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductModel> products;
  final int wholesalerCount;
  final bool forward;

  OrderModel({
    required this.id,
    required this.vendorId,
    required this.customerId,
    required this.orderId,
    required this.orderForwarded,
    required this.name,
    required this.email,
    required this.avatar,
    required this.items,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.products,
    required this.wholesalerCount,
    required this.forward,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      orderForwarded: int.tryParse(json['orderForwarded']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      items: int.tryParse(json['items']?.toString() ?? '0') ?? 0,
      price: json['price']?.toString() ?? '0',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      products: (json['products'] as List? ?? [])
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      wholesalerCount:
          int.tryParse(json['wholesalerCount']?.toString() ?? '0') ?? 0,
      forward: json['forward'] == true,
    );
  }
}

/// =======================================================
/// PRODUCT MODEL
/// =======================================================
class ProductModel {
  final String id;
  final String name;
  final String category;
  final String? image; // <-- FIXED (nullable)
  final List<ProductImage> images;
  final String price;
  final int quantity;
  final String discount;
  final num sellingPrice;
  final num costPrice;
  final String currency;
  final String internationalShippingPrice;
  final String? editedImageURL;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    this.image,
    required this.images,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.sellingPrice,
    required this.costPrice,
    required this.currency,
    required this.internationalShippingPrice,
    this.editedImageURL,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString(),
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      price: json['price']?.toString() ?? '0',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      discount: json['discount']?.toString() ?? '0',
      sellingPrice: num.tryParse(json['sellingPrice']?.toString() ?? '0') ?? 0,
      costPrice: num.tryParse(json['costPrice']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? '',
      internationalShippingPrice:
          json['internationalshippingPrice']?.toString() ?? '0',
      editedImageURL: json['editedImageURL']?.toString(),
    );
  }
}

/// =======================================================
/// PRODUCT IMAGE MODEL
/// =======================================================
class ProductImage {
  final String id;
  final String image;

  ProductImage({
    required this.id,
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
