import 'package:flutter/material.dart';

class CartItem {
  final String cartItemId;
  final String productId;
  final String name;
  final String image;
  final String size;
  final Color color;
  final double price;
  int qty;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.size,
    required this.color,
    required this.price,
    required this.qty,
  });

  double get total => price * qty;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      productId: json['productId'],
      name: json['productName'],
      image: json['image'],
      size: json['selectedSize'],
      qty: json['quantity'],
      price: double.parse(json['sellingPrice']),
      color: _hexToColor(json['selectedColor']),
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
