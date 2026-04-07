import 'package:flutter/material.dart';

import '../../data/model/cart/cart_model.dart';
import '../../service/cart/addto_cart_api.dart';
import '../../service/cart/cart_api.dart';
import '../../service/cart/update_cart_api.dart';

// class CartController with ChangeNotifier {
//   CartResponse? _cartData;
//   bool _isLoading = false;
//   String? _error;
//
//   CartResponse? get cartData => _cartData;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   Future<void> fetchCart() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       _cartData = await CartApiService.fetchCart();
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> removeItem(String productId) async {
//     try {
//       await CartApiService.removeCartItem(productId);
//       await fetchCart(); // Refresh cart data
//     } catch (e) {
//       _error = e.toString();
//       notifyListeners();
//     }
//   }
// }

class CartController with ChangeNotifier {
  CartResponse? _cartData;
  bool _isLoading = false;
  String? _error;

  CartResponse? get cartData => _cartData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cartData = await CartApiService.fetchCart();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart({
    required String productId,
    required int quantity,
    required String vendorId,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await AddToCartApiService.addToCart(
        productId: productId,
        quantity: quantity,
        vendorId: vendorId,
      );

      // Immediately refresh cart data after successful addition
      await fetchCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      _error = null;
    } catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> removeItem(String productId) async {
    try {
      await CartApiService.removeCartItem([productId]);  // Pass as a list
      await fetchCart(); // Refresh cart data
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  Future<void> updateToCart({
    required String productId,
    required int quantity,
    required String vendorId,
    required BuildContext context,
  }) async {
    if (_isLoading) return; // Prevent multiple simultaneous requests
    _isLoading = true;
    notifyListeners();

    try {
      final response = await UpdateCartApiService.UpdateToCart(
        productId: productId,
        quantity: quantity,
        vendorId: vendorId,
      );

      // Refresh cart data
      await fetchCart();

      // Check if widget is still mounted before showing snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: response['success'] ? Colors.green : Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      // Check if widget is still mounted before showing error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error!),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
