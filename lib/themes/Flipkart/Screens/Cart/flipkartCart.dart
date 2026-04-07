import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/cart_controller.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/checkoutController/checheckout.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Cart/checkoutForm.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Cart/guestCartScreen.dart';
import 'package:one_click_builder/themes/Flipkart/api/payment/paymenttype.dart';
import 'package:shimmer/shimmer.dart';

import '../Home/SiginScreen/signinScreen.dart';

class FlipkartCartScreen extends StatefulWidget {
  const FlipkartCartScreen({super.key});

  @override
  State<FlipkartCartScreen> createState() => _FlipkartCartScreenState();
}

class _FlipkartCartScreenState extends State<FlipkartCartScreen> {
  final vendorCtrl = Get.find<FlipkartVendorController>();
  final cartCtrl = Get.find<CartController>();
  final checkoutCtrl = Get.put(CheckoutController());
  String? country, state, city;
  String? vendorId;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    await cartCtrl.checkLogin(vendorId.toString());

    if (cartCtrl.isLoggedIn.value) {
      final vendorId = vendorCtrl.vendorId.value;
      if (vendorId.isNotEmpty) {
        await cartCtrl.loadCart(vendorId);
        _loadPaymentTypes(vendorId);
      }
    }
  }

  Future<void> _loadPaymentTypes(String vendorId) async {
    final paymentService = PaymentService();
    final types = await paymentService.getDeliveryTypes(vendorId);

    checkoutCtrl.deliveryTypes.assignAll(types);

    if (types.contains("cod")) {
      checkoutCtrl.selectedPaymentMethod.value = "cod";
    } else if (types.isNotEmpty) {
      checkoutCtrl.selectedPaymentMethod.value = types.first;
    }
  }

  String _safeImage(String? url) {
    if (url == null || url.trim().isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!cartCtrl.isLoggedIn.value) return GuestCartScreen();
      if (cartCtrl.isLoading.value) return _loadingUI();

      final cart = cartCtrl.cart.value;
      if (cart == null || cart.items.isEmpty) return _emptyCartUI();

      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffF6F6F6),
          appBar: AppBar(
            title: Obx(() {
              final count = cartCtrl.cartCount.value;
              return Text("My Cart ($count)");
            }),
          ),
          body: Column(
            children: [
              Expanded(child: _cartList(cart)),
              _orderSummary(cart),
            ],
          ),
        ),
      );
    });
  }

  // ---------------- UI STATES ----------------

  Widget _loadingUI() {
    return Scaffold(
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: 120, height: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _notLoggedInUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 16),
            const Text("You are not logged in"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => FlipkartSignInScreen()),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCartUI() {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final count = cartCtrl.cartCount.value;
          return Text("My Cart ($count)");
        }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🛒 GIF
            Padding(
              padding: const EdgeInsets.only(right: 90),
              child: Image.asset(
                "assets/shopingcart.gif", // <-- update your path
                height: 180,
              ),
            ),

            const SizedBox(height: 20),

            // 📝 Text
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- CART LIST ----------------
  Widget _cartList(cart) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cart.items.length,
      itemBuilder: (_, index) {
        final item = cart.items[index];
        final vendorId = vendorCtrl.vendorId.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP ROW (Image + Title)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
             ClipRRect(
  borderRadius: BorderRadius.circular(6),
  child: Image.network(
    _safeImage(item.image),
    height: 90,
    width: 90,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 90,
        width: 90,
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 30,
        ),
      );
    },
  ),
),
                  const SizedBox(width: 12),

                  // TITLE + PRICE + RATING
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ⭐ Rating
                        // Row(
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //       decoration: BoxDecoration(
                        //         color: Colors.green,
                        //         borderRadius: BorderRadius.circular(4),
                        //       ),
                        //       child: Row(
                        //         children: const [
                        //           Text("4.7", style: TextStyle(color: Colors.white, fontSize: 12)),
                        //           Icon(Icons.star, color: Colors.white, size: 12),
                        //         ],
                        //       ),
                        //     ),
                        //     const SizedBox(width: 6),
                        //     const Text("(9)", style: TextStyle(color: Colors.grey)),
                        //   ],
                        // ),

                        // const SizedBox(height: 6),

                        // Price Section
                        Row(
                          children: [
                            // Selling Price
                            Text(
                              "₹${item.sellingPrice}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 6),

                            // Show MRP & Discount only if MRP > Selling Price
                            if (item.mrpPrice > item.sellingPrice) ...[
                              Text(
                                "₹${item.mrpPrice}",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${(((item.mrpPrice - item.sellingPrice) / item.mrpPrice) * 100).round()}% OFF",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Qty Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _qtyBtn(Icons.remove, () => cartCtrl.decreaseQty(index)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(item.quantity.toString()),
                      ),
                      _qtyBtn(Icons.add, () => cartCtrl.increaseQty(index)),
                    ],
                  ),
               
                ],
              ),

              const Divider(height: 20),

              // ACTION BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:  [

       Obx(() {
                    final isDeleting =
                        cartCtrl.deletingItemId.value == item.cartItemId;

                    return isDeleting
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        // : IconButton(
                        //     icon: const Icon(Icons.delete, color: Colors.red),
                        //     onPressed: () {
                        //       cartCtrl.removeItem(
                        //         cartItemId: item.cartItemId,
                        //         VendorId: vendorId,
                        //       );
                        //     },
                 :    GestureDetector(
                     onTap: () {
                              cartCtrl.removeItem(
                                cartItemId: item.cartItemId,
                                VendorId: vendorId,
                              );
                            },
                    
                    child: Text("Remove",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600)),
                  );
                  }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _orderSummary(cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // PRICE BREAKUP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("MRP"),
              Text(" ₹${cart.totalPrice.toStringAsFixed(2)}"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Fees"),
              Text("₹ 0"),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: const [
          //     Text("Discounts"),
          //     Text("₹ 0", style: TextStyle(color: Colors.green)),
          //   ],
          // ),

          const Divider(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₹${cart.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Container(
          //   padding: const EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     color: Colors.green.shade50,
          //     borderRadius: BorderRadius.circular(6),
          //   ),
          //   child: const Text(
          //     "✔ You'll save ₹594 on this order!",
          //     style:
          //         TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
          //   ),
          // ),

          const SizedBox(height: 20),

          // Bottom Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showCheckoutForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CHECKOUT ----------------

  void _showCheckoutForm() {
    CheckoutBottomSheet.open(context, cartCtrl, vendorCtrl);
  }

  // ---------------- HELPERS ----------------

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _summaryRow(String title, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style:
              TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}

class CheckoutBottomSheet {
  static void open(BuildContext context, cartCtrl, vendorCtrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CheckoutForm(cartCtrl: cartCtrl, vendorCtrl: vendorCtrl),
    );
  }
}
