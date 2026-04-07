import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/api/Sigin/guestsigin.dart';
import 'package:one_click_builder/themes/Flipkart/api/cart/nexusCart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;




/// ================= RESULT ENUM =================
enum CartAddResult {
  success,
  alreadyExists,
  notLoggedIn,
  error,
}

class CartController extends GetxController {
var isLoading = false.obs;
  var isAddingToCart = false.obs; // ✅ MISSING (NOW ADDED)
  var cart = Rxn<CartResponse>();
    var isLoggedIn = false.obs;
    var deletingItemId = "".obs; // 👈 track which item is being deleted

RxInt cartCount = 0.obs; // ✅ no conflict now



Future<void> checkLogin(String vendorId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  debugPrint("🔑 Main User Token: $token");

  if (token != null && token.isNotEmpty) {
    isLoggedIn.value = true;
    return;
  }

  // User NOT logged in → guest login
  String? guestToken = await guestLogin(vendorId);

 

  isLoggedIn.value = false;
}




  /// ================= LOAD CART =================
Future<void> loadCart(String vendorId) async {
  try {
    isLoading.value = true;

    final response = await CartService.fetchCart(vendorId);
    cart.value = response;
cartCount.value = response.totalQuantity;


    debugPrint("✅ Cart loaded: ${response.items.length} items");
  } catch (e) {
    debugPrint("❌ Cart error: $e");
    cart.value = CartResponse(
      totalPrice: 0,
      totalQuantity: 0,
      items: [],
    );
  } finally {
    isLoading.value = false;
  }
}


  /// ================= ADD TO CART =================


  /// ================= QUANTITY =================
  void increaseQty(int index) {
    cart.update((c) {
      if (c == null) return;
      c.items[index].quantity++;
      _recalculateTotal(c);
    });
  }

  void decreaseQty(int index) {
    cart.update((c) {
      if (c == null) return;
      if (c.items[index].quantity > 1) {
        c.items[index].quantity--;
        _recalculateTotal(c);
      }
    });
  }

  /// ================= DELETE ITEM =================
  /// 
  /// 
  /// 


Future<void> removeItem({
  required String cartItemId,
  required String VendorId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    Get.snackbar(
      'Session Expired',
      'Please login again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  try {
    deletingItemId.value = cartItemId; // 👈 START loader
    final url = 'https://api.1clickbuilder.com/api/cart/remove-item/$VendorId';
    final body = jsonEncode({
      "productId": [cartItemId],
    });

    final response = await http
        .delete(
          Uri.parse(url),
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body, // 👈 IMPORTANT!
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      cart.update((c) {
        if (c == null) return;
        c.items.removeWhere((e) => e.cartItemId == cartItemId);
        _recalculateTotal(c);
      });

      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    } else {
      // ❌ API FAILED
      Get.snackbar(
        'Failed',
        'Unable to remove item. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      debugPrint("❌ Delete failed: ${response.statusCode}");
      debugPrint("❌ Body: ${response.body}");
    }
  } on TimeoutException {
    Get.snackbar(
      'Timeout',
      'Server taking too long. Try again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  } catch (e) {
    // ❌ NO INTERNET / CRASH
    Get.snackbar(
      'Error',
      'Something went wrong. Check your internet connection.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    debugPrint("❌ Delete exception: $e");
  } finally {
    deletingItemId.value = ""; // 👈 STOP loader always
  }
}


// for delete items from cart when oder place sucessfuly




Future<bool> removeItem1({
  required String cartItemId,
  required String VendorId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null || token.isEmpty) {
    Get.snackbar(
      'Session Expired',
      'Please login again',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return false;
  }

  try {
    deletingItemId.value = cartItemId; // 👈 START loader

    final url =
        'https://api.1clickbuilder.com/api/cart/remove-item/$VendorId';

        print(url);

  final body = jsonEncode({
  "productId": [cartItemId],  // 👈 Always send as array
});


    final response = await http
        .delete(
          Uri.parse(url),
          headers: {
            'Authorization': token,
            'Content-Type': 'application/json',
          },
          body: body, // 👈 IMPORTANT!
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      cart.update((c) {
        if (c == null) return;
        c.items.removeWhere((e) => e.cartItemId == cartItemId);
        _recalculateTotal(c);
      });
      return true;
    }
    return false;
  } on TimeoutException {
    return false;
  } catch (e) {
    debugPrint("❌ Delete exception: $e");
  } finally {
    deletingItemId.value = ""; // 👈 STOP loader always
  }
  return false;
}


  /// ================= TOTAL =================
void _recalculateTotal(CartResponse c) {
  c.totalPrice = c.items.fold(
    0.0,
    (sum, item) => sum + (item.sellingPrice * item.quantity),
  );

  final totalQty = c.items.fold(
    0,
    (sum, item) => sum + item.quantity,
  );

  cartCount.value = totalQty;
}

}
