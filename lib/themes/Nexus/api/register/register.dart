import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';

class RegisterController extends GetxController {
  final NexusVendorController vendorCtrl = Get.find();

  RxBool isLoading = false.obs;

  /// Register API Call
  Future<void> registerUser({
    required String first,
    required String last,
    required String mobile,
    required String password,
    required String confirm,
    String? email,
  }) async {
    final String vendorId = vendorCtrl.vendorId.value.trim();
    if (vendorId.isEmpty) {
      Get.snackbar(
        "Error",
        "Store details are still loading. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    final String normalizedMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');
    final body = <String, dynamic>{
      "firstName": first,
      "lastName": last,
      "mobile": normalizedMobile,
      "password": password,
      "confirmPassword": confirm,
      "vendorId": vendorId,
    };
    if (email != null && email.trim().isNotEmpty) {
      body["email"] = email.trim();
    }

    try {
      final response = await http.post(
        Uri.parse("${NexusAppConstant.baseUrl}${NexusAppConstant.registerUrl}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final dynamic decodedBody = jsonDecode(response.body);
      final Map<String, dynamic> data = decodedBody is Map<String, dynamic>
          ? decodedBody
          : <String, dynamic>{};

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["error"] == null) {
        Get.snackbar(
          "Success",
          data["data"]?["message"] ?? "Registered Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(() => const NexusSignInScreen());
        });
        return;
      }

      Get.snackbar(
        "Error",
        _extractErrorMessage(data) ?? "Registration Failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (_) {
      Get.snackbar(
        "Error",
        "Unable to register right now. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> decoded) {
    final error = decoded["error"];
    if (error is String && error.isNotEmpty) {
      return error;
    }
    if (error is Map<String, dynamic>) {
      final message = error["message"];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    final data = decoded["data"];
    if (data is Map<String, dynamic>) {
      final message = data["message"];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }
}
