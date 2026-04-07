import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../data/model/home/best_selling_product_model.dart';
import '../authentication/login/login_page.dart';
import '../cart/abc.dart';
import '../checkout_screen/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final List<Variant> variants;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.variants,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    // final variants = widget.variants;
    print(product.images!.first.image);
    print("object");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Quick View"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product.images != null &&
                    product.images!.isNotEmpty &&
                    product.images!.first.image != null
                    ? Image.network(
                  product.images!.first.image!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : const Placeholder(fallbackHeight: 250),
              ),
              WishlistButton(
                productId: product.id ?? "",
                productImageId: product.images!.first.id ?? "",
              ),
            ]),
            const SizedBox(height: 16),
            Text(
              " ${product.title}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('SKU: ${product.sku}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '₹${product.costPrice}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${product.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Colors : No color available'),
            const Text('Size : No size available'),
            const SizedBox(height: 12),
            const Text('Quantity:',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              width: 110,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(quantity.toString(),
                      style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: Colors.pinkAccent)),
                child: const Text(
                  "ADD TO CART",
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              onTap: () {
                final cartController =
                Provider.of<CartController>(context, listen: false);
                cartController.addToCart(
                  productId: product.id.toString(),
                  quantity: quantity,
                  vendorId: product.vendorId.toString(),
                  context: context,
                );
              },
            ),
            const SizedBox(height: 16),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return GestureDetector(
                  onTap: () {
                    if (userProvider.userResponse != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              // controller: CheckoutController(),
                              // product: product,
                            )),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Not Logged In"),
                            content: const Text(
                                "You are not logged in. Please login to continue."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginPage()),
                                  );
                                },
                                child: const Text("Login"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      "BUY IT NOW",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}