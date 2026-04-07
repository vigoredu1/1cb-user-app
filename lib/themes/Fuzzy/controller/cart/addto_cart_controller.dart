// import 'package:flutter/material.dart';
//
// import '../../service/cart/addto_cart_api.dart';
//
// class AddToCartController with ChangeNotifier {
//   bool _isLoading = false;
//   String? _error;
//
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//
//   Future<void> addToCart({
//     required String productId,
//     required int quantity,
//     required String vendorId,
//     required BuildContext context,
//   }) async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final response = await AddToCartApiService.addToCart(
//         productId: productId,
//         quantity: quantity,
//         vendorId: vendorId,
//       );
//
//       // Determine snackbar color based on success status
//       final snackBarColor = response['success'] ? Colors.green : Colors.orange;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(response['message']),
//           backgroundColor: snackBarColor,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(_error!),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
