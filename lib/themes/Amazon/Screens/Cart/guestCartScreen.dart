import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Modules/Cart/guestCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Amazon/api/cart/guestCart.dart';

class GuestCartScreen extends StatefulWidget {
  @override
  _GuestCartScreenState createState() => _GuestCartScreenState();
}

class _GuestCartScreenState extends State<GuestCartScreen> {
  bool loading = true;
  List<CartItem> items = [];
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
      items = itemList.map((e) => CartItem.fromJson(e)).toList();
      totalPrice = data["cart"]["totalPrice"]?.toString() ?? "0";
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   // title: Text(
      //   //   "My Cart (${items.length})",
      //   //   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      //   // ),
      // ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? _amazonEmptyGuestCart(context)
          : _guestCartList(),
    );
  }

  // ---------------- AMAZON EMPTY CART UI ----------------

  Widget _amazonEmptyGuestCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right:65),
              child: Image.asset(
                "assets/shopingcart.gif", // 👈 add this asset
                height: 160,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Your Cart is empty",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Shop today's deals",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            const SizedBox(height: 24),

            // SIGN IN BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AmzSignInScreen()),
                  );
                },
                child: const Text(
                  "Sign in to your account",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // SIGN UP BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AmzSignInScreen()),
                  );
                },
                child: const Text(
                  "Sign up now",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- GUEST CART LIST ----------------

  // Widget _guestCartList() {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: ListView.builder(
  //           padding: const EdgeInsets.all(14),
  //           itemCount: items.length,
  //           itemBuilder: (context, i) {
  //             return _buildCartCard(items[i]);
  //           },
  //         ),
  //       ),
  //
  //       // ORDER SUMMARY
  //       Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(14),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.06),
  //               blurRadius: 10,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             _priceRow("Subtotal", totalPrice),
  //             const Divider(),
  //             _priceRow("Total Amount", totalPrice,
  //                 isBold: true, color: Colors.green),
  //           ],
  //         ),
  //       ),
  //
  //       // PROCEED BUTTON
  //       Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: SizedBox(
  //           width: double.infinity,
  //           height: 55,
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.pinkAccent.shade100,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(14),
  //               ),
  //             ),
  //             onPressed: () => _showLoginRequiredDialog(context),
  //             child: const Text(
  //               "PROCEED Guest TO CHECKOUT",
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //         ),
  //       ),
  //
  //       const SizedBox(height: 90),
  //     ],
  //   );
  // }
  Widget _guestCartList() {
    return CustomScrollView(
      slivers: [
        // const SizedBox(height: 30),

        // 🔥 STICKY PROCEED TO BUY BAR (AMAZON STYLE)
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          toolbarHeight: 110,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Subtotal ₹$totalPrice",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => _showLoginRequiredDialog(context),
                    child: Text(
                      "Proceed to Buy (${items.length} item)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🛒 PRODUCT LIST (SAME UI)
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: _buildCartCard(items[i]),
            ),
            childCount: items.length,
          ),
        ),

        // EXTRA SPACE BOTTOM
        const SliverToBoxAdapter(
          child: SizedBox(height: 30),
        ),
      ],
    );
  }

  // ---------------- HELPERS ----------------

  Widget _priceRow(String title, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:
            TextStyle(fontSize: isBold ? 18 : 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(
          "₹$value",
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
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
                MaterialPageRoute(builder: (_) => AmzSignInScreen()),
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image,
              height: 100,
              width: 90,
              fit: BoxFit.cover,
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
        ],
      ),
    );
  }
}
