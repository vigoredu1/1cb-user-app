import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Cart/checkoutForm.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Cart/guestCartScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/checkoutController/checheckout.dart';
import 'package:one_click_builder/themes/Amazon/api/payment/paymenttype.dart';
import '../Home/SiginScreen/signinScreen.dart';

class AmzCartScreen extends StatefulWidget {
  const AmzCartScreen({super.key});

  @override
  State<AmzCartScreen> createState() => _AmzCartScreenState();
}

class _AmzCartScreenState extends State<AmzCartScreen> {
  final vendorCtrl = Get.find<AmzVendorController>();
  final cartCtrl = Get.find<AmzCartController>();
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
        // appBar: AppBar(
        //   title: Obx(() {
        //     final count = cartCtrl.cartCount.value;
        //     return Text("My Cart ($count)");
        //   }),
        // ),
        body: Column(
          children: [
            SizedBox(height: 35,),
            Expanded(child: _cartWithStickyProceed(cart)),
            // _orderSummary(cart),
          ],
        ),
      );
    });
  }

  // ---------------- UI STATES ----------------
  Widget _cartWithStickyProceed(cart) {
    return CustomScrollView(
      slivers: [

        // 🔥 STICKY PROCEED TO BUY (SAME LOOK)
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          toolbarHeight: 114,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 9),
            child: Column(
              children: [
                _summaryRow("Total", cart.totalPrice),

                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary, // ✅ same
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // ✅ same
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutForm(
                            cartCtrl: cartCtrl,
                            vendorCtrl: vendorCtrl,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Proceed to Buy (${cart.items.length} item)",
                      style: const TextStyle(
                        fontSize: 16,color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🛒 PRODUCT LIST (already Amazon style)
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) =>
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  child: _cartItemCard(cart.items[index], index),
                ),
            childCount: cart.items.length,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }

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


  Widget _emptyCartUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/shopingcart.gif", // 👈 add this asset
                height: 160,
              ),
              const SizedBox(height: 24),
              const Text(
                "Your Cart is empty",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
           
            ],
          ),
        ),
      ),
    );
  }
  Widget _cartItemCard(item, int index) {
    final vendorId = vendorCtrl.vendorId.value;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ClipRRect(
  borderRadius: BorderRadius.circular(10),
  child: Image.network(
    _safeImage(item.image),
    height: 100,
    width: 90,
    fit: BoxFit.cover,

    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return Container(
        height: 100,
        width: 90,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    },

    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 100,
        width: 90,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported),
      );
    },
  ),
),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "₹${item.sellingPrice}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
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
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    cartCtrl.removeItem(
                      cartItemId: item.cartItemId,
                      VendorId: vendorId,
                    );
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _qtyBtn(Icons.remove,
                          () => cartCtrl.decreaseQty(index)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(item.quantity.toString()),
                  ),
                  _qtyBtn(Icons.add,
                          () => cartCtrl.increaseQty(index)),
                ],
              ),
              Text(
                "₹${(item.sellingPrice * item.quantity).toStringAsFixed(2)}",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }



  // ---------------- ORDER SUMMARY ----------------



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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title,          style:
    TextStyle(fontWeight:  FontWeight.w800,fontSize: 28),
    ),
        SizedBox(width: 15,),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style:
              TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal,fontSize: 20),
        ),
      ],
    );
  }
}



