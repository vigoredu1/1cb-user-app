import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/userprofile_provider.dart';
import '../../utility/local_storage.dart';
import '../../view/screen/authentication/login/login_page.dart';
import '../../view/screen/dashboard_screens/wishlist_screen.dart';
import '../screens/ordersummery_screen.dart';

class FeaturesListWidget extends StatelessWidget {
  const FeaturesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final tokken = StorageHelper.getToken();
    // final vendorId = StorageHelper.getVendorId();
    return Column(children: [
      /*** Orders List ***/
      ListTile(
          leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 30,
                color: Colors.black87,
              )),
          title: const Text(
            "Orders",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            "Ongoing orders,resent orders..",
            style: TextStyle(
                color: Colors.grey.shade400, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const OrderSummeryScreen()),
            );
          }),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Divider(color: Colors.grey.shade300),
      ),
      /*** Wish List ***/
      ListTile(
          leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.favorite_border,
                size: 30,
                color: Colors.black87,
              )),
          title: const Text(
            "Wishlist",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            "Your Saved Products",
            style: TextStyle(
                color: Colors.grey.shade400, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const WishlistScreen()),
            );
          }),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Divider(color: Colors.grey.shade300),
      ),
      /*** Payment Method ***/
      // ListTile(
      //     leading: Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //             color: Colors.grey.shade200,
      //             borderRadius: BorderRadius.circular(10)),
      //         child: const Icon(
      //           Icons.account_balance_wallet_outlined,
      //           size: 30,
      //         )),
      //     title: const Text(
      //       "Payment",
      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //     ),
      //     subtitle: Text(
      //       "Saved Card Wallet",
      //       style: TextStyle(
      //           color: Colors.grey.shade400, fontWeight: FontWeight.w600),
      //     ),
      //     onTap: () {}),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10, right: 10),
      //   child: Divider(color: Colors.grey.shade300),
      // ),
      /*** Saved Address ***/
      // ListTile(
      //     leading: Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //             color: Colors.grey.shade200,
      //             borderRadius: BorderRadius.circular(10)),
      //         child: const Icon(
      //           Icons.location_on_outlined,
      //           size: 30,
      //         )),
      //     title: const Text(
      //       "Saved Address",
      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //     ),
      //     subtitle: Text(
      //       "Home Address",
      //       style: TextStyle(
      //           color: Colors.grey.shade400, fontWeight: FontWeight.w600),
      //     ),
      //     onTap: () {}),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10, right: 10),
      //   child: Divider(color: Colors.grey.shade300),
      // ),
      /*** Language ***/
      // ListTile(
      //     leading: Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //             color: Colors.grey.shade200,
      //             borderRadius: BorderRadius.circular(10)),
      //         child: const Icon(
      //           Icons.language,
      //           size: 30,
      //         )),
      //     title: const Text(
      //       "Language",
      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //     ),
      //     subtitle: Text(
      //       "Select your language here",
      //       style: TextStyle(
      //           color: Colors.grey.shade400, fontWeight: FontWeight.w600),
      //     ),
      //     onTap: () {}),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10, right: 10),
      //   child: Divider(color: Colors.grey.shade300),
      // ),
      /*** Currency ***/
      // ListTile(
      //     leading: Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //             color: Colors.grey.shade200,
      //             borderRadius: BorderRadius.circular(10)),
      //         child: const Icon(
      //           Icons.currency_exchange,
      //           size: 30,
      //         )),
      //     title: const Text(
      //       "Currency",
      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //     ),
      //     subtitle: Text(
      //       "Change your Currency here",
      //       style: TextStyle(
      //           color: Colors.grey.shade400, fontWeight: FontWeight.w600),
      //     ),
      //     onTap: () {}),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10, right: 10),
      //   child: Divider(color: Colors.grey.shade300),
      // ),

      /*** Setting ***/
      // ListTile(
      //     leading: Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //             color: Colors.grey.shade200,
      //             borderRadius: BorderRadius.circular(10)),
      //         child: const Icon(
      //           Icons.settings,
      //           size: 30,
      //         )),
      //     title: const Text(
      //       "Setting",
      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //     ),
      //     subtitle: Text(
      //       "RTL, Dark mode, notifications",
      //       style: TextStyle(
      //           color: Colors.grey.shade400, fontWeight: FontWeight.w600),
      //     ),
      //     onTap: () {}),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10, right: 10),
      //   child: Divider(color: Colors.grey.shade300),
      // ),
      /*** Terms & Conditions ***/
      // ListTile(
      //     leading: Container(
      //         height: 40,
      //         width: 40,
      //         decoration: BoxDecoration(
      //             color: Colors.grey.shade200,
      //             borderRadius: BorderRadius.circular(10)),
      //         child: const Icon(
      //           Icons.notification_important_outlined,
      //           size: 25,
      //         )),
      //     title: const Text(
      //       "Term & Condition",
      //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      //     ),
      //     subtitle: Text(
      //       "Select your language here",
      //       style: TextStyle(
      //           color: Colors.grey.shade400, fontWeight: FontWeight.w600),
      //     ),
      //     onTap: () {}),
      // Padding(
      //   padding: const EdgeInsets.only(left: 10, right: 10),
      //   child: Divider(color: Colors.grey.shade300),
      // ),
      /*** Logout button ***/
      Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.userResponse != null) {
            return ListTile(
              leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.login,
                    size: 25,
                    color: Colors.black87,
                  )),
              title: const Text(
                "Logout",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // userProvider.userResponse?.user.email.;
                            StorageHelper.removeToken();
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          } else {
            return ListTile(
              leading: const Icon(Icons.login),
              title: Text("Login"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            );
          }
        },
      ),
    ]);
  }
}
