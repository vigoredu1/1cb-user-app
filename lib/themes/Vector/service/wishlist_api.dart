import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../data/model/all_wishlist_product_model.dart';
import '../utility/app_constant.dart';
import '../utility/local_storage.dart';

class WishlistProvider with ChangeNotifier {
  final Set<String> _wishlistItems = {};
  Set<String> get wishlistItems => _wishlistItems;
  List<WishlistProduct> _wishlistProducts = [];
  List<WishlistProduct> get wishlistProducts => _wishlistProducts;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchWishlistIds() async {
    try {
      final vendorId = await StorageHelper.getVendorId();
      final token = await StorageHelper.getToken();
      if (token == null || vendorId == null) return;
      final url = "${AppConstant.baseUrl}${AppConstant.allWishlistGetUrl}$vendorId";
      print(" url of wishlist");
      print(url);

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List products = data['data']?['products'] ?? [];

        _wishlistItems.clear();
        for (var item in products) {
          _wishlistItems.add(item['id']);
        }
        notifyListeners();
      } else {
        print(" Failed to fetch wishlist: ${response.body}");
      }
    } catch (e) {
      print(" Fetch Wishlist IDs Error: $e");
    }
  }

  Future<void> fetchWishlistProducts(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    print("========== FETCH WISHLIST START ==========");

    try {
      final vendorId = await StorageHelper.getVendorId();
      final token = await StorageHelper.getToken();

      print("Vendor ID : $vendorId");
      print("Token     : $token");

      if (vendorId == null || token == null) {
        print("⚠ User not logged in");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url = "${AppConstant.baseUrl}${AppConstant.allWishlistGetUrl}$vendorId";

      print("API URL   : $url");

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': token,
      });

      print("Status Code: ${response.statusCode}");
      print("Response Raw: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Parsed JSON: $jsonData");

        final model = ProductWishlistModel.fromJson(jsonData);

        _wishlistProducts = model.data?.products ?? [];

        print("Wishlist Product Count: ${_wishlistProducts.length}");
        for (var item in _wishlistProducts) {
          print("Product ID: ${item.id}, Title: ${item.title}");
        }

      } else {
        final jsonData = jsonDecode(response.body);
        final errorMsg = jsonData['error']?['message'] ?? "Failed to fetch wishlist";
        print("❌ Error Message: $errorMsg");
        _showSnackBar(context, errorMsg, Colors.red);
      }
    } catch (e) {
      print("❌ Exception: $e");
      _showSnackBar(context, "Something went wrong", Colors.red);
    }

    _isLoading = false;
    print("========== FETCH WISHLIST END ==========\n");
    notifyListeners();
  }

  Future<void> removeWishlistItem({
    required String productId,
    required String productImageId,  // Added productImageId as required parameter
    required BuildContext context,
  }) async {
    final vendorId = await StorageHelper.getVendorId();
    final token = await StorageHelper.getToken();

    if (vendorId == null || token == null) {
      _showSnackBar(context, "Authentication error", Colors.red);
      return;
    }

    final url = "${AppConstant.baseUrl}${AppConstant.wishlistRemoveUrl}/$productId/$vendorId";

    try {
      _wishlistProducts.removeWhere((item) => item.id == productId);
      _wishlistItems.remove(productId);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"productImageId": productImageId}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final message = jsonData['data']?['message'] ?? "Removed from wishlist";
        _showSnackBar(context, message, Colors.red);
      } else {
        _showSnackBar(context, "Failed to remove product", Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, "Error removing product: $e", Colors.red);
    }
  }

  ///yha
  Future<void> fetchWishlist() async {
    try {
      final vendorId = await StorageHelper.getVendorId();
      final token = await StorageHelper.getToken();
      final url = "${AppConstant.baseUrl}${AppConstant.wishlistUrl}$vendorId";

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': '$token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> items = data['data'] ?? [];

        _wishlistItems.clear();
        for (var item in items) {
          _wishlistItems.add(item['productId']);
        }

        notifyListeners();
      }
    } catch (e) {
      print(" Fetch Wishlist Error: $e");
    }
  }

  Future<void> toggleWishlist({
    required String productId,
    required String productImageId,  // Added productImageId as required parameter
    required BuildContext context,
  }) async {
    final vendorId = await StorageHelper.getVendorId();
    final token = await StorageHelper.getToken();

    print("🔍 vendorId: $vendorId");
    print("🔍 token: $token");

    if (vendorId == null || token == null) {
      _showSnackBar(context, "Missing vendor or token", Colors.red);
      return;
    }

    final isRemoving = _wishlistItems.contains(productId);

    if (isRemoving) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.add(productId);
    }
    notifyListeners();

    ///yha
    // Updated URL: For add, include vendorId in path as per curl; for remove, use the new remove URL
    final String url = isRemoving
        ? "${AppConstant.baseUrl}${AppConstant.wishlistRemoveUrl}/$productId/$vendorId"
        : "${AppConstant.baseUrl}${AppConstant.wishlistUrl}/$vendorId";

    print("📌 FINAL URL => $url");
    print("📌 METHOD => ${isRemoving ? "DELETE" : "POST"}");

    try {
      http.Response response;

      // Prepare body: For add, use curl format; for remove, use new format
      final body = isRemoving
          ? jsonEncode({"productImageId": productImageId})
          : jsonEncode({"productId": productId, "vendorId": vendorId, "productImageId": productImageId});

      print("📩 BODY => $body");
      print("📩 HEADERS => ${{
        'Accept': 'application/json, text/plain, */*',
        'Authorization': token,
        'Content-Type': 'application/json',
      }}");

      if (isRemoving) {
        response = await http.delete(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json, text/plain, */*',
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body,
        );
      } else {
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Accept': 'application/json, text/plain, */*',
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body,
        );
      }

      print("📤 STATUS CODE => ${response.statusCode}");
      print("📤 RAW RESPONSE => ${response.body}");

      final status = response.statusCode;
      final resBody = jsonDecode(response.body);

      if (status == 200 || status == 201) {
        final message = resBody['data']?['message'] ??
            (isRemoving ? "Removed from wishlist" : "Added to wishlist");
        _showSnackBar(context, message, isRemoving ? Colors.red : Colors.green);
      } else {
        final errorMsg = resBody['error']?['message'] ?? "Operation failed";
        _showSnackBar(context, errorMsg, Colors.red);
      }
    } catch (e) {
      print("❌ EXCEPTION => $e");
      _showSnackBar(context, "Error: $e", Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}