import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../core_widget/common_button.dart';
import '../../../data/model/cart/cart_model.dart';
import '../dashboard_screens/dashboard.dart';

class ViewCart_Screen extends StatelessWidget {
  const ViewCart_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('View Cart')),
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
            return Center(child: Text('Error: ${controller.error}'));
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
                    return ViewCartItemWidget(
                      item: item,
                      onRemove: () => controller.removeItem(item.productId),
                    );
                  },
                ),
              ),
              ViewCartSummary(cart: cartData.cart!),
            ],
          );
        },
      ),
    );
  }
}

class ViewCartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;

  const ViewCartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Product Image
            if (item.images.isNotEmpty)
              Image.network(
                item.images.first,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image),
              ),
            const SizedBox(width: 12),
            // Product Detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: ₹${item.sellingPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Text('Quantity: '),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item.quantity > 1) {
                            // onQuantityChanged(item.quantity - 1);
                          }
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        item.quantity.toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // onQuantityChanged(item.quantity + 1);
                        },
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class ViewCartSummary extends StatelessWidget {
  final Cart cart;

  const ViewCartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text('Order Summery',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal', style: TextStyle(fontSize: 16)),
              Text(
                "₹${cart.totalPrice.toString()}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                '₹${cart.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CommonButton(
                onTap: () {},
                // backgroundColor: Colors.white,
                // textColor: Colors.black,
                buttonText: "Process To Checkout"),
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardScreen()));
              },
              child: const Text(
                "Continue Shopping",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ))
        ],
      ),
    );
  }
}
