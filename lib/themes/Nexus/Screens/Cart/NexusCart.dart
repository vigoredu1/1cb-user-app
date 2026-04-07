import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Cart/checkoutForm.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Cart/guestCartScreen.dart';
import 'package:one_click_builder/themes/Nexus/api/orderTypes/orderTypes.dart';
import 'package:shimmer/shimmer.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Nexus/Controllers/checkoutController/checheckout.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import '../Home/SiginScreen/signinScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final vendorCtrl = Get.find<NexusVendorController>();
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

      return Scaffold(
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
              onPressed: () => Get.to(() => NexusSignInScreen()),
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

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.network(
                      _safeImage(item.image),
                      height: 80,
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item.productName)),
                    Obx(() {
                      final isDeleting =
                          cartCtrl.deletingItemId.value == item.cartItemId;

                      return isDeleting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cartCtrl.removeItem(
                                  cartItemId: item.cartItemId,
                                  VendorId: vendorId,
                                );
                              },
                            );
                    })
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${item.sellingPrice}"),
                    Row(
                      children: [
                        _qtyBtn(
                            Icons.remove, () => cartCtrl.decreaseQty(index)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(item.quantity.toString()),
                        ),
                        _qtyBtn(Icons.add, () => cartCtrl.increaseQty(index)),
                      ],
                    ),
                    Text(
                      "₹${(item.sellingPrice * item.quantity).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- ORDER SUMMARY ----------------

  Widget _orderSummary(cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow("Subtotal", cart.totalPrice),
          _summaryRow("Total", cart.totalPrice, bold: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showCheckoutForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF28BA8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart_checkout),
                  SizedBox(width: 8),
                  Text(
                    "PROCEED TO CHECKOUT",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 70),
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
