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
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItem.fromJson(e))
          .toList(),
      coupons: json['coupons'] ?? [],
    );
  }
}
class Cart {
  final String id;
  final String userId;
  final String totalPrice;
  final int totalQuantity;
  final String totalPayablePrice;
  final String totalDiscountedPrice;
  final String vendorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.totalQuantity,
    required this.totalPayablePrice,
    required this.totalDiscountedPrice,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      totalPrice: json['totalPrice'] ?? '0',
      totalQuantity: json['totalQuantity'] ?? 0,
      totalPayablePrice: json['totalPayablePrice'] ?? '0',
      totalDiscountedPrice: json['totalDiscountedPrice'] ?? '0',
      vendorId: json['vendorId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
class CartItem {
  final String cartItemId;
  final String productId;
  final String productName;
  final int quantity;
  final String sellingPrice;
  final String mrpPrice;
  final String discountingPrice;
  final String selectedSize;
  final String selectedColor;
  final String image;
  final String currency;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.sellingPrice,
    required this.mrpPrice,
    required this.discountingPrice,
    required this.selectedSize,
    required this.selectedColor,
    required this.image,
    required this.currency,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      sellingPrice: json['sellingPrice'] ?? '0',
      mrpPrice: json['mrpPrice'] ?? '0',
      discountingPrice: json['discountingPrice'] ?? '0',
      selectedSize: json['selectedSize'] ?? '',
      selectedColor: json['selectedColor'] ?? '',
      image: json['image'] ?? '',
      currency: json['currency'] ?? '',
    );
  }
}
