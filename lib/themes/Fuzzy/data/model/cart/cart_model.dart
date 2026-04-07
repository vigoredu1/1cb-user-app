class CartResponse {
  final Cart? cart;
  final List<CartItem> items;
  final List<dynamic> coupons;

  CartResponse({
    required this.cart,
    required this.items,
    required this.coupons,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cart: json['cart'] != null ? Cart.fromJson(json['cart']) : null,
      items: List<CartItem>.from(
          json['items']?.map((x) => CartItem.fromJson(x)) ?? []),
      coupons: json['coupons'] ?? [],
    );
  }
}

class Cart {
  final String id;
  final String userId;
  final double totalPrice;
  final int totalQuantity;
  final double totalPayablePrice;
  final double totalDiscountedPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String vendorId;

  Cart({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.totalQuantity,
    required this.totalPayablePrice,
    required this.totalDiscountedPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.vendorId,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      totalPrice: double.parse(json['totalPrice'] ?? '0'),
      totalQuantity: json['totalQuantity'] ?? 0,
      totalPayablePrice: double.parse(json['totalPayablePrice'] ?? '0'),
      totalDiscountedPrice: double.parse(json['totalDiscountedPrice'] ?? '0'),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      vendorId: json['vendorId'],
    );
  }
}

class CartItem {
  final String productId;
  final int quantity;
  final double sellingPrice;
  final double discountingPrice;
  final double mrpPrice;
  final String productName;
  final String taxesAndCharges;
  final dynamic taxOptions;
  final double packagingCharges;
  final double shippingPrice;
  String productImageId;
  final List<String> images;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.sellingPrice,
    required this.discountingPrice,
    required this.mrpPrice,
    required this.productName,
    required this.taxesAndCharges,
    required this.taxOptions,
    required this.packagingCharges,
    required this.shippingPrice,
    required this.productImageId,
    required this.images,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      quantity: json['quantity'],
      sellingPrice: double.parse(json['sellingPrice'] ?? '0'),
      discountingPrice: double.parse(json['discountingPrice'] ?? '0'),
      mrpPrice: double.parse(json['mrpPrice'] ?? '0'),
      productName: json['productName'],
      taxesAndCharges: json['taxesAndCharges'],
      taxOptions: json['taxOptions'],
      packagingCharges: json['packagingCharges']?.toDouble() ?? 0.0,
      shippingPrice: double.parse(json['shippingPrice'] ?? '0'),
      productImageId: json['productImageId'],
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
