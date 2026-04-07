import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/orders/NexusOrders.dart';
import 'package:one_click_builder/themes/Flipkart/api/FlipkartOrder/orderResponse.dart';

class ProfileOrdersController extends GetxController {
  /// Orders list
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  /// Loading state
  final RxBool isLoading = true.obs;

  /// Optional message from API
  final RxString message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {


    print("fetch orders list data"); 
    try {
      isLoading.value = true;

      final response = await OrderApi.fetchOrders();

      orders.value = response.data?.orders ?? [];
      message.value = response.data?.message ?? '';

    } catch (e) {
       print('error $e');

      Get.snackbar('Error', "Something Went Wrong",
      backgroundColor: Colors.red);
      Color:Colors.white;
    } finally {
      isLoading.value = false;
    }
  }

  // =======================================================
  // DERIVED DATA
  // =======================================================

  int get totalOrders => orders.length;

  int get awaitingPickup =>
      orders.where((o) => o.status.toLowerCase() == 'pending').length;

  int get cancelledOrders =>
    orders.where((o) {
      final status = o.status.trim().toLowerCase();
      return status == 'canceled' || status == 'cancelled';
    }).length;


  // =======================================================
  // PROFILE DATA (FROM FIRST ORDER)
  // =======================================================

  String get userName =>
      orders.isNotEmpty ? orders.first.name : '';

  String get userEmail =>
      orders.isNotEmpty ? orders.first.email : '';

  /// Avatar preference:
  /// 1️⃣ Order avatar
  /// 2️⃣ Product image fallback
  String get avatar {
    if (orders.isEmpty) return '';

    if (orders.first.avatar.isNotEmpty) {
      return orders.first.avatar;
    }

    if (orders.first.products.isNotEmpty &&
        orders.first.products.first.images.isNotEmpty) {
      return orders.first.products.first.images.first.image;
    }

    return '';
  }
}
