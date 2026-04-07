import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/profile/profileController.dart';
import 'package:one_click_builder/themes/Nexus/api/NexusOrder/deleteOrders.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';
import 'package:one_click_builder/themes/Nexus/utility/plugin_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class OrdersReturnScreen extends StatefulWidget {
  const OrdersReturnScreen({super.key});

  @override
  _OrdersReturnScreenState createState() => _OrdersReturnScreenState();
}

class _OrdersReturnScreenState extends State<OrdersReturnScreen> {
  final controller = Get.put(ProfileOrdersController());

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      controller.fetchOrders(); // 🔥 fetch instantly
    });
  }

  void _showCancelOrderPopup(BuildContext context, String orderId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.red, size: 60),

            const SizedBox(height: 16),

            const Text(
              "Cancel Order?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Are you sure you want to cancel this order? This action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("No"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _cancelOrder(orderId);
                    },
                    child: const Text("Yes, Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
void _cancelOrder(String orderId) async {
  Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );

  final success = await DeleteOrderService.deleteOrder(orderId);

  if (Get.isDialogOpen == true) Get.back();

  if (success) {
    Get.snackbar(
      "Success",
      "Order cancelled successfully",
      backgroundColor: Colors.green.shade100,
    );

    controller.fetchOrders(); // 🔥 refresh list
  } else {
    Get.snackbar(
      "Error",
      "Failed to cancel order",
      backgroundColor: Colors.red.shade100,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      appBar: AppBar(
        title: const Text("Orders"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 120,
                height: 20,
                color: Colors.white,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent Orders",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _ordersList(),
            ],
          ),
        );
      }),
    );
  }

  // =======================================================
  // ORDERS LIST
  // =======================================================
  Widget _ordersList() {
    // 🔥 If no orders found
    if (controller.orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 210),
            child: Column(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 70, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  "No Orders Found",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: controller.orders.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final order = controller.orders[index];
        final product = order.products.isNotEmpty ? order.products.first : null;
        final imageUrl = product != null &&
                product.images.isNotEmpty &&
                product.images.first.image.isNotEmpty
            ? product.images.first.image
            : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _showOrderDetails(context, order);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 72,
                          width: 72,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 72,
                          width: 72,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.name ?? "Product",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product?.category ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text("${order.items} items"),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat("dd MMM yyyy, hh:mm a")
                          .format(order.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${order.price}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                 
      // ✅ CANCEL ORDER BUTTON
                  if (order.status.toLowerCase() == "pending")
                    GestureDetector(
                      onTap: () {
                        _showCancelOrderPopup(context, order.id);
                      },
                      child: const Text(
                        "Cancel Order",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      _fetchShipmentStatus(context, order.orderId);
                    },
                    child: SizedBox(
                      child: const Text(
                        "Check Status",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =======================================================
  // STATUS COLOR
  // =======================================================
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showOrderDetails(BuildContext context, order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- TITLE & CLOSE BUTTON ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order Items",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // -------- PRODUCT LIST ----------
              ...order.products.map((product) {
                final img = product.images.isNotEmpty
                    ? product.images.first.image
                    : null;

                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: img != null
                            ? Image.network(
                                img,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 70,
                                width: 70,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image),
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.category,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Qty: ${product.quantity}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Text(
                        "₹${product.price}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),

              // ---------- BOTTOM TOTAL ----------
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Order Total:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "₹${order.price}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _fetchShipmentStatus(BuildContext context, String orderId) async {
    // SHOW LOADER
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url = Uri.parse(
      "${NexusAppConstant.baseUrl}/api/shiprocket/get-order-details/$orderId",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": token.toString(),
        },
      );

      // HIDE LOADER
      if (Get.isDialogOpen == true) Get.back();

      final result = jsonDecode(response.body);
      print(response.body);
      print('kkkkkkkk');
      final data = result["data"];

      // If items status is null → Pending
      final List items = data["items"] ?? [];

String finalStatus = "";

// check item status first
if (items.isNotEmpty && items.first["status"] != null) {
  finalStatus = items.first["status"];
}
// fallback to user_status
else if (data["user_status"] != null) {
  finalStatus = data["user_status"];
}
// fallback to main status
else if (data["status"] != null) {
  finalStatus = data["status"];
} else {
  finalStatus = "Pending";
}

      String message = data["message"] ?? "";

      _showShipmentPopup(
        context,
        title: "Shipment Details",
        status: finalStatus,
        orderId: data["order_id"] ?? "",
        message: message.isEmpty ? "No status message provided." : message,
      );
    } catch (e) {
      // HIDE LOADER
      if (Get.isDialogOpen == true) Get.back();

      Get.snackbar("Error", "Failed to load shipment status");
    }
  }

  void _showShipmentPopup(
    BuildContext context, {
    required String title,
    required String status,
    required String orderId,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // Shipment Status (Big bold)
              Text(
                status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: status.toLowerCase() == "cancelled"
                      ? Colors.red
                      : Colors.orange,
                ),
              ),

              const SizedBox(height: 20),

              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Order Status: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: status),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Order ID: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: orderId),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Message: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: message),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
