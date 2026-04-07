import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Cart/guestCart.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Flipkart/api/cart/guestCart.dart';


class GuestCartScreen extends StatefulWidget {
  const GuestCartScreen({super.key});

  @override
  _GuestCartScreenState createState() => _GuestCartScreenState();
}

class _GuestCartScreenState extends State<GuestCartScreen> {
  bool loading = true;
  List<CartItem> items = []; // FIXED
  String totalPrice = "0";

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    setState(() => loading = true);

    final data = await GuestCartService.fetchGuestCart();

    if (data != null) {
      List itemList = data["items"] ?? [];

      /// FIXED: Mapping to CartItem
      items = itemList.map((e) => CartItem.fromJson(e)).toList();

      totalPrice = data["cart"]["totalPrice"]?.toString() ?? "0";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Cart (${items.length})",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
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
      )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(14),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          return _buildCartCard(item);
                        },
                      ),
                    ),

                    // subtotal total
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Subtotal", style: TextStyle(fontSize: 16)),
                              Text("₹$totalPrice",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text("₹$totalPrice",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Proceed button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            _showLoginRequiredDialog(context);
                          },
                          child: Text(
                            "PROCEED TO CHECKOUT",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 90,
                    )
                  ],
                ),
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please login to access this feature."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlipkartSignInScreen()),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  Widget _buildCartCard(CartItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image, // FIXED
              height: 100,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  item.productName,
                  style: TextStyle(fontSize: 14, height: 1.3),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 10),

                SizedBox(height: 8),

                Row(
                  children: [
                    Text("₹${item.sellingPrice}", // FIXED PRICE
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Spacer(),

            

                    Spacer(),

                    Text(
                        "₹${item.sellingPrice}", // total price per quantity? If needed I can calc
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
