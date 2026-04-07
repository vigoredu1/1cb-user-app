
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../core_widget/common_button.dart';
import '../../../data/model/cart/cart_model.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/local_storage.dart';
import '../authentication/login/layout/login_image.dart';
import '../authentication/login/login_page.dart';
import '../checkout_screen/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final controller = Provider.of<CartController>(context, listen: false);
    // final tokken = StorageHelper.getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.cartData == null && !controller.isLoading) {
        controller.fetchCart();
      }
    });
    return userProvider.userResponse != null
        ? _buildCartContent(context)
        : _buildLoginPrompt(context);
  }

  Widget _buildCartContent(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Consumer<CartController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
          }

          if (controller.error != null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 100,
                  ),
                ],
              ),
            );
          }

          final cartData = controller.cartData;
          if (cartData == null || cartData.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartData.items.length,
                  itemBuilder: (context, index) {
                    final item = cartData.items[index];
                    return CartItemWidget(
                      item: item,
                      onRemove: () => controller.removeItem(item.productId),
                    );
                  },
                ),
              ),
              CartSummary(cart: cartData.cart!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginImage(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Currently you are not login",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          CommonButton(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              buttonText: "Sign in")
        ],
      )),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    int quantity = item.quantity;
    final vendorId = StorageHelper.getVendorId();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: Colors.grey[100],
        color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Product Image
              if (item.images.isNotEmpty)
                Image.network(
                  "${item.images}",
                  width: 80,
                  height: 80,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.broken_image_rounded,
                    size: 80,
                    color: AppTheme.fromType(AppTheme.defaultTheme)
                        .backGroundColorMain,
                  ),
                ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${item.quantity}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '₹${item.mrpPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Remove Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child:
                        // SvgPicture.asset(
                        //   SvgAssets.icon.,
                        //   fit: BoxFit.scaleDown,
                        //   height: 20,
                        //   width: 20,
                        // )
                        IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.black87),
                      onPressed: onRemove,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(color: Colors.grey.shade100)),
                            child: IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () async {
                                print("Addd");
                                print(vendorId.toString());
                                print(item.productId);
                                await cartController.updateToCart(
                                  productId: item.productId,
                                  quantity: item.quantity - 1,
                                  vendorId: vendorId.toString(),
                                  context: context,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(quantity.toString()),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                print("Addd");
                                print(vendorId.toString());
                                print(item.productId);
                                await cartController.updateToCart(
                                  productId: item.productId,
                                  quantity: item.quantity + 1,
                                  vendorId: vendorId.toString(),
                                  context: context,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
}

class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('Total Price',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  Text(
                    '₹${cart.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Expanded(
                  child: CommonButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CheckoutScreen()));
                      },
                      buttonText: "Checkout"))
            ],
          ),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }
}
