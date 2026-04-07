import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:one_click_builder/themes/Amazon/api/payment/paymenttype.dart';
import 'package:get/get.dart';


import 'package:flutter/material.dart';
class CheckoutController extends GetxController {

  // ---------------- TEXT CONTROLLERS ----------------
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  // ---------------- PHONE ----------------
  var phoneCode = "+91".obs;

  // ---------------- LOCATION ----------------
  var country = "".obs;
  var state = "".obs;
  var city = "".obs;

  // ---------------- PAYMENT ----------------
  var deliveryTypes = <String>[].obs;
  var selectedPaymentMethod = "cod".obs;

  // ---------------- ORDER STATE ----------------
  var isPlacingOrder = false.obs;

  // ---------------- API ----------------
  Future<void> loadDeliveryTypes(String vendorId) async {
    final service = PaymentService();
    deliveryTypes.value = await service.getDeliveryTypes(vendorId);

    if (deliveryTypes.isNotEmpty) {
      selectedPaymentMethod.value = deliveryTypes.first;
    }
  }

  // ---------------- HELPERS ----------------
  bool get isFormValid {
    return nameCtrl.text.isNotEmpty &&
        phoneCtrl.text.isNotEmpty &&
        addressCtrl.text.isNotEmpty &&
        country.value.isNotEmpty &&
        state.value.isNotEmpty &&
        city.value.isNotEmpty;
  }

  void clearForm() {
    nameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    zipCtrl.clear();
    addressCtrl.clear();

    country.value = "";
    state.value = "";
    city.value = "";
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    zipCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}
