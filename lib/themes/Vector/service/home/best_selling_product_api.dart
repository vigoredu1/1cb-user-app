import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../data/model/home/best_selling_product_model.dart';
import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

// class BestSellingProductProvider with ChangeNotifier {
//   BestSellerModel? _bestSellerModel;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   BestSellerModel? get bestSellerModel => _bestSellerModel;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//
//   Future<void> fetchBestSellerProducts() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     final vendorId = await StorageHelper.getVendorId();
//     final String url = "${AppConstant.baseUrl}${AppConstant.bestSellingProduct}$vendorId";
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       final statusCode = response.statusCode;
//       //
//       // print(" Request URL: $url");
//       // print(" Response Status: $statusCode");
//
//       if (statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         _bestSellerModel = BestSellerModel.fromJson(jsonData);
//         print(" Best Selling Products Fetched");
//         print(response.body);
//       } else {
//         _bestSellerModel = null;
//
//         if (statusCode == 400) {
//           _errorMessage = "Bad Request: Please check parameters or vendor ID.";
//         } else if (statusCode == 404) {
//           _errorMessage = "Not Found: No best selling products available.";
//         } else {
//           _errorMessage = "Error: Failed to fetch data. Status code $statusCode.";
//         }
//
//         print(" $_errorMessage");
//         print(" Response Body: ${response.body}");
//       }
//     } catch (e) {
//       _bestSellerModel = null;
//       _errorMessage = "Exception: Best Selling Failed to fetch best selling products.";
//
//       print(" Exception Occurred Best Selling : $e");
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
// }
class BestSellingProductProvider with ChangeNotifier {
  BestSellerModel? _bestSellerModel;
  bool _isLoading = false;
  String? _errorMessage;

  BestSellerModel? get bestSellerModel => _bestSellerModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBestSellerProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final vendorId = await StorageHelper.getVendorId();
      final token = await StorageHelper.getToken();

      if (vendorId == null || vendorId.isEmpty) {
        _errorMessage = "Vendor ID not available.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final url =
          "${AppConstant.baseUrl}${AppConstant.bestSellingProduct}$vendorId";

      final headers = {
        "Content-Type": "application/json",
      };

      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      final response = await http.get(Uri.parse(url), headers: headers);
      final statusCode = response.statusCode;

      if (statusCode == 200) {
        final jsonData = json.decode(response.body);
        _bestSellerModel = BestSellerModel.fromJson(jsonData);
        debugPrint(
            "✅ Best Selling Products Fetched: ${_bestSellerModel?.data?.length ?? 0}");
      } else {
        _bestSellerModel = null;

        if (statusCode == 400) {
          _errorMessage = "Bad Request: Check parameters or vendor ID.";
        } else if (statusCode == 401) {
          _errorMessage = "Unauthorized: Invalid or missing token.";
        } else if (statusCode == 404) {
          _errorMessage = "Not Found: No best selling products available.";
        } else {
          _errorMessage =
              "Error: Failed to fetch data. Status code $statusCode.";
        }

        debugPrint("❌ $_errorMessage");
        debugPrint("Response Body: ${response.body}");
      }
    } catch (e) {
      _bestSellerModel = null;
      _errorMessage = "Exception: Failed to fetch best selling products.";
      debugPrint("❌ Exception Occurred Best Selling: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
