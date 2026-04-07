import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartService {
  static const String _baseUrl =
      '${NexusAppConstant.baseUrl}${NexusAppConstant.catUrl}';

  /// 🔹 FETCH CART BY VENDOR ID
  static Future<CartResponse> fetchCart(String vendorId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final guestId = prefs.getString('guestId'); // optional

    // 🔹 Build URL with nullable guestId
    String apiUrl = '$_baseUrl/$vendorId?guestUserId=${guestId ?? ''}';

    final url = Uri.parse(apiUrl);

    print("🛒 Cart API URL: $apiUrl");

    // 🔥 token optional (guest allowed)
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = token;
    }

    print("🛒 Cart API called");
    final response = await http.get(url, headers: headers);

    print("📦 Cart Response: ${response.body}");
    print("📦 Status Code: ${response.statusCode}");

    // If user is logged-in, then validate token
    if (token != null && token.isNotEmpty) {
      final body = json.decode(response.body);

      if (body['error'] != null &&
          body['error']['error'] == 'FailedToAuthenticate') {
        await _clearUserSession(prefs);

        Get.snackbar(
          'Session Expired',
          'Please login again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        throw Exception('SessionExpired');
      }
    }

    // ---- existing parsing logic continues ----
    final body = json.decode(response.body);

    double total = 0;
    int quantity = 0;
    List<CartItem> items = [];

    final data = body['data'];

    if (data is List) {
      items = data.map<CartItem>((e) {
        final item = CartItem.fromJson(e);
        total += item.sellingPrice * item.quantity;
        quantity += item.quantity;
        return item;
      }).toList();
    } else if (data is Map) {
      final List listItems = data['items'] ?? [];
      items = listItems.map<CartItem>((e) {
        final item = CartItem.fromJson(e);
        total += item.sellingPrice * item.quantity;
        quantity += item.quantity;
        return item;
      }).toList();
    }

    return CartResponse(
      totalPrice: total,
      totalQuantity: quantity,
      items: items,
    );
  }

  static Future<void> _clearUserSession(SharedPreferences prefs) async {
    const keys = [
      'token',
      'auth_token',
      'email',
      'name',
      'mobile',
      'profile_picture',
      'role',
      'guestId',
    ];
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

class CartResponse {
  double totalPrice;
  final int totalQuantity;
  final List<CartItem> items;

  CartResponse({
    required this.totalPrice,
    required this.totalQuantity,
    required this.items,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final cart = data['cart'] ?? {};
    final itemsJson = data['items'] ?? [];

    return CartResponse(
      totalPrice: double.tryParse(cart['totalPrice']?.toString() ?? '0') ?? 0.0,
      totalQuantity:
          int.tryParse(cart['totalQuantity']?.toString() ?? '0') ?? 0,
      items: List<CartItem>.from(
        itemsJson.map((x) => CartItem.fromJson(x)),
      ),
    );
  }
}

class CartItem {
  final String cartItemId;
  final String productId;
  int quantity;
  final double sellingPrice;
  final double mrpPrice;
  final double discountingPrice;
  final String? selectedColor;
  final String? selectedSize;
  final String image;
  final String productName;

  // ✅ EXTRA API FIELDS (added)
  final String cartId;
  final String userId;
  final String createdAt;
  final String updatedAt;
  final int isImported;
  final String taxesAndCharges;
  final String? taxOptions;
  final int packagingCharges;
  final String shippingPrice;
  final String internationalShippingPrice;
  final String currency;
  final String productImageId;
  final String sizes;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.quantity,
    required this.sellingPrice,
    required this.mrpPrice,
    required this.discountingPrice,
    this.selectedColor,
    this.selectedSize,
    required this.image,
    required this.productName,

    // extra
    required this.cartId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isImported,
    required this.taxesAndCharges,
    this.taxOptions,
    required this.packagingCharges,
    required this.shippingPrice,
    required this.internationalShippingPrice,
    required this.currency,
    required this.productImageId,
    required this.sizes,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      sellingPrice:
          double.tryParse(json['sellingPrice']?.toString() ?? '0') ?? 0.0,
      mrpPrice: double.tryParse(json['mrpPrice']?.toString() ?? '0') ?? 0.0,
      discountingPrice:
          double.tryParse(json['discountingPrice']?.toString() ?? '0') ?? 0.0,
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize']?.toString(),
      image: (json['image'] is String && json['image'].toString().isNotEmpty)
          ? json['image']
          : '',
      productName: json['productName']?.toString() ?? '',

      // ✅ extra mappings
      cartId: json['cartId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      isImported: int.tryParse(json['is_imported']?.toString() ?? '0') ?? 0,
      taxesAndCharges: json['taxesAndCharges']?.toString() ?? '0',
      taxOptions: json['taxOptions'],
      packagingCharges:
          int.tryParse(json['packagingCharges']?.toString() ?? '0') ?? 0,
      shippingPrice: json['shippingPrice']?.toString() ?? '0',
      internationalShippingPrice:
          json['internationalshippingPrice']?.toString() ?? '0',
      currency: json['currency']?.toString() ?? '',
      productImageId: json['productImageId']?.toString() ?? '',
      sizes: json['sizes']?.toString() ?? '',
    );
  }
}
