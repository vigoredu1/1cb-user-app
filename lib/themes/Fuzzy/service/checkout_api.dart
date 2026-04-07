import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../data/model/home/checkout_model.dart';
import '../utility/app_constant.dart';
import '../utility/local_storage.dart';
import '../view/screen/checkout_screen/checkout_response.dart';

class CheckoutProvider with ChangeNotifier {
  CheckoutResponseModel? _checkoutResponse;
  bool _isLoading = false;
  String? _errorMessage;

  CheckoutResponseModel? get checkoutResponse => _checkoutResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> checkoutCreateOrder(OrderCreateModel orderCreateModel) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const String url = "${AppConstant.baseUrl}${AppConstant.checkoutCreateOrderUrl}";
    final token = await StorageHelper.getToken();
    final Map<String, dynamic> bodyMap = orderCreateModel.toJson();
    final String body = jsonEncode(bodyMap);

    print("========== [ Checkout API DEBUG ] ==========");
    print(" URL: $url");
    print(" TOKEN: $token");
    print(" BODY MAP: $bodyMap");
    print("=============================================");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': "$token",
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final statusCode = response.statusCode;

      print(" RESPONSE STATUS: $statusCode");
      print(" RESPONSE BODY: ${response.body}");
      print(" RESPONSE HEADERS: ${response.headers}");
      print("=============================================");

      if (statusCode == 200 || statusCode == 201) {
        final jsonData = json.decode(response.body);
        _checkoutResponse = CheckoutResponseModel.fromJson(jsonData);
      } else {
        _checkoutResponse = null;
        _errorMessage = "Error $statusCode: ${response.body}";
      }
    } catch (e) {
      _checkoutResponse = null;
      _errorMessage = "Exception: $e";
      print(" Exception Occurred: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
