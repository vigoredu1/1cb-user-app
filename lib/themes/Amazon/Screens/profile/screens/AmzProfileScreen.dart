import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/ContactUsScreen.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/OrdersReturnsScreen.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/aboutScreen.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/camcellationPolicy.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/myProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Controllers/profile/profileController.dart';
import '../../RegisterAccount/regiisterAccount.dart';

//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   bool isLoggedIn = false;
//   bool isCheckingLogin = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   /// CHECK LOGIN STATUS
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('token');
//
//     setState(() {
//       isLoggedIn = userId != null && userId.isNotEmpty;
//       isCheckingLogin = false; // ✅ login check completed
//     });
//   }
//
//   /// LOGOUT
// Future<void> _logout(BuildContext context) async {
//   final prefs = await SharedPreferences.getInstance();
//
//   // Clear local storage
//   await prefs.clear();
//
//   // Delete all active GetX controllers
//   //Get.deleteAll(force: true);
//
//   // Optional: Reset entire GetX state (recommended)
//   // Get.reset();
//
//   // Navigate to Sign In screen
//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(builder: (_) => AmzSignInScreen()),
//     (route) => false,
//   );
// }
//
//
//   /// LOGIN REQUIRED DIALOG
//   void _showLoginRequiredDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Login Required"),
//         content: const Text("Please login to access this feature."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => AmzSignInScreen()),
//               );
//             },
//             child: const Text("Login"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ITEM CLICK HANDLER
//   void _handleItemClick(BuildContext context, VoidCallback onSuccess) async {
//     if (!isLoggedIn) {
//       _showLoginRequiredDialog(context);
//       return;
//     }
//     onSuccess();
//   }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: const Color(0xFFF6F2FF),
//
//     appBar: AppBar(
//       title: const Text("My Account"),
//       centerTitle: false,
//       elevation: 0,
//     ),
//
//     body: isCheckingLogin
//         ?  Center(child:  Shimmer.fromColors(
//     baseColor: Colors.grey.shade300,
//     highlightColor: Colors.grey.shade100,
//     child: Container(
//       width: 120,
//       height: 20,
//       color: Colors.white,
//     ),
//   ),)
//         : SingleChildScrollView(
//             padding: const EdgeInsets.only(bottom: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionTitle("Account"),
//                 _card([
//                   _item(context, Icons.person_outline, "My Profile", () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ProfileDashboardScreen(),
//                       ),
//                     );
//                   }),
//                   _item(context, Icons.shopping_bag_outlined,
//                       "Orders & Returns", () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>  OrdersReturnScreen(),
//                       ),
//                     );
//                   }),
//                 ]),
//
//                 _sectionTitle("Information"),
//                 _card([
//                   _item(context, Icons.info_outline, "About Us", _aboutUs),
//                   _item(context, Icons.cancel_outlined,
//                       "Cancellation Policy", _openPolicy),
//                   _item(context, Icons.phone_in_talk_outlined,
//                       "Contact Us", () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ContactUsScreen(),
//                       ),
//                     );
//                   }),
//                 ]),
//
//                 const SizedBox(height: 24),
//
//                 // 🔐 LOGIN BANNER
//                 if (!isLoggedIn) _loginBanner(context),
//
//                 // 🔓 LOGOUT BUTTON
//                 if (isLoggedIn) _logoutButton(context),
//               ],
//             ),
//           ),
//   );
// }
// Widget _loginBanner(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     child: Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF6C4AB6).withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Login to your account",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             "Track orders, manage profile and get personalized offers.",
//             style: TextStyle(color: Color(0xFF6B6B6B)),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             height: 48,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFF4D6D),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => AmzSignInScreen(),
//                   ),
//                 );
//               },
//               child: const Text(
//                 "Login",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Widget _logoutButton(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     child: SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: ElevatedButton.icon(
//         icon: const Icon(Icons.logout),
//         label: const Text("Logout"),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.redAccent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         onPressed: () async {
//           // Show confirmation dialog
//           final shouldLogout = await showDialog<bool>(
//             context: context,
//             barrierDismissible: false, // user must tap a button
//             builder: (ctx) => AlertDialog(
//               title: const Text("Confirm Logout"),
//               content: const Text("Are you sure you want to exit?"),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(ctx).pop(false),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                   ),
//                   onPressed: () => Navigator.of(ctx).pop(true),
//                   child: const Text("Yes"),
//                 ),
//               ],
//             ),
//           );
//
//           // If user confirmed, call your logout function
//           if (shouldLogout == true) {
//             _logout(context);
//           }
//         },
//       ),
//     ),
//   );
// }
//
//
//
//   /// SECTION TITLE
//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   /// CARD
//   Widget _card(List<Widget> children) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(children: children),
//     );
//   }
//
//   /// LIST ITEM
// Widget _item(
//   BuildContext context,
//   IconData icon,
//   String title,
//   VoidCallback onTap,
// ) {
//   return Column(
//     children: [
//       ListTile(
//         leading: Icon(icon, color: Colors.blue),
//         title: Text(title),
//         trailing: const Icon(Icons.chevron_right),
//         onTap: () => _handleItemClick(context, onTap),
//       ),
//
//       // 👇 small subtle line
//       const Divider(
//         height: 0,
//         thickness: 0.6,
//         indent: 56,      // aligns after icon
//         endIndent: 12,
//         color: Color(0xFFE5E5E5),
//       ),
//     ],
//   );
// }
//
//
//   void _aboutUs() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => NexusAboutScreen(),
//       ),
//     );
//   }
//
//   void _openPolicy() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CancellationPolicyScreen(),
//       ),
//     );
//   }
// }
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  bool isCheckingLogin = true;
  String userEmail = "guest@amazon.in";
  String userName = "User";
  final List<String> _greetings = [
    "హలో",
    "नमस्ते",
    "Hello",
    "வணக்கம்",
    "नमस्ते"
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _greetings.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final email = prefs.getString('email');
    final name = prefs.getString('name');

    setState(() {
      isLoggedIn = token != null && token.isNotEmpty;
      userEmail = email ?? "guest@amazon.in";
      userName = name ?? "User";
      isCheckingLogin = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in const [
      'token',
      'auth_token',
      'email',
      'name',
      'mobile',
      'profile_picture',
      'role',
      'guestId',
    ]) {
      await prefs.remove(key);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AmzSignInScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isCheckingLogin
          ? _loadingView()
          : Column(
              children: [
                Expanded(
                  child: isLoggedIn ? _loggedInUI() : _guestUI(),
                ),
              ],
            ),
    );
  }

  // Future<Widget> _loggedInUI() async {
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _userHeader(),
  //         _quickActions(),
  //         _divider(),
  //
  //         InkWell( onTap:       () => Get.to(() => OrdersReturnScreen()),
  //
  //             child: _section("Your Orders")),
  //         _horizontalProducts(),
  //         _divider(),
  //         // _section("Buy Again"),
  //         // _horizontalProducts(),
  //         // _section("Your Account"),
  //         // _accountActions(),
  //         // _divider(),
  //         // _logoutButton(),
  //         const SizedBox(height: 30),
  //       ],
  //     ),
  //   );
  // }
  Widget _loggedInUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userHeader(),
          InkWell(
              onTap: () => Get.to(() => OrdersReturnScreen()),
              child: _quickActions()),
          _divider(),
          InkWell(
            onTap: () => Get.to(() => OrdersReturnScreen()),
            child: _section("Your Orders"),
          ),
          _horizontalProducts(),
          _divider(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _guestUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Sign in to your account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "View your wish list",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 12),

            const Text(
              "Find & reorder past purchases",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 12),

            const Text(
              "Track your purchases",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 35),

            // SIGN IN BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4C86A),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFFBFA24A)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AmzSignInScreen()),
                  );
                },
                child: const Text(
                  "Already a customer? Sign in",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // CREATE ACCOUNT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CreateAccountScreen()),
                  );
                },
                child: const Text(
                  "New user? Create an account",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _quickActions() {
    final items = ["Orders"];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(items[i],
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String text, Color bg, Color txt,
      {bool hasBorder = false,
      required VoidCallback onTap} // Added onTap parameter
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: txt,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
              side: BorderSide(
                  color: hasBorder
                      ? Colors.grey.withOpacity(0.80)
                      : Colors.black.withOpacity(0.50)),
            ),
          ),
          child: Text(text, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  void _showUserSwitchSheet(
    BuildContext context,
    String name,
    String email,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Who is shopping?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // User Profile Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor:
                        Color(0xFF7BA8BC), // Matching the blue-grey in image
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      // ACCOUNT HOLDER IN CONTAINER
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Account holder",
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    // onTap: () => Get.to(() => ProfileDashboardScreen()),
                    child: const Text(
                      "",
                      style: TextStyle(color: Colors.teal, fontSize: 16),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 25),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Add profile",
              //         style: TextStyle(color: Colors.teal, fontSize: 16)),
              //     Text("Remove profile",
              //         style: TextStyle(color: Colors.grey, fontSize: 16)),
              //   ],
              // ),
              const Divider(height: 40),
              Center(
                child: Text(
                  "Signed in as $email",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ),
              const SizedBox(height: 5),
              //
              // // SWITCH ACCOUNTS BUTTON WITH SHADOW
              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 4,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: OutlinedButton(
              //     onPressed: () {},
              //     style: OutlinedButton.styleFrom(
              //       side: BorderSide(color: Colors.grey.shade300),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8)),
              //     ),
              //     child: const Text(
              //       "Switch Accounts",
              //       style: TextStyle(color: Colors.black, fontSize: 16),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 15),

              // SIGN OUT BUTTON
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close sheet
                    _showLogoutConfirmation(
                        context); // Trigger your logout logic
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.teal, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Your actual logic from previous turn
                // await JweStorageHelper.removeToken();
                _logout(context);
                Navigator.pop(context);
                // Navigator.of(context).pushReplacement(...)
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Widget _userHeader() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 2),
          Text(
            "Hello, $userName",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              _showUserSwitchSheet(context, userName, userEmail);
            },
            icon: Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(Widget leadingWidget, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        children: [
          SizedBox(width: 40, height: 40, child: Center(child: leadingWidget)),
          const SizedBox(width: 20),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 16, height: 1.3, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("See all", style: TextStyle(color: Colors.teal)),
          ],
        ),
      );

  Widget _divider() => const Divider(thickness: 4, color: Color(0xFFE0E0E0));
  Widget _horizontalProducts() {
    final controller = Get.find<ProfileOrdersController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 140,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.orders.isEmpty) {
        return const SizedBox(
          height: 140,
          child: Center(child: Text("No Orders Found")),
        );
      }

      return SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.orders.length,
          itemBuilder: (_, index) {
            final order = controller.orders[index];
            final product =
                order.products.isNotEmpty ? order.products.first : null;

            final image = product != null && product.images.isNotEmpty
                ? product.images.first.image
                : null;

            return Container(
              width: 140,
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: image != null && image.trim().isNotEmpty
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Container(
                                      //color: Colors.grey.shade200,
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Container(
                                  //color: Colors.grey.shade200,
                                  child: const Icon(Icons.image),
                                ),
                              ),
                      ),
                    ),
                  )

                  // // INFO
                  // Padding(
                  //   padding: const EdgeInsets.all(8),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         product?.name ?? "Product",
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: const TextStyle(
                  //             fontSize: 12, fontWeight: FontWeight.bold),
                  //       ),
                  //       const SizedBox(height: 4),
                  //       Text(
                  //         "₹${order.price}",
                  //         style: const TextStyle(
                  //             fontSize: 12, color: Colors.black),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _accountActions() {
    final items = ["Your Account", "Amazon Pay", "Addresses", "View All"];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(items[i])),
        ),
      ),
    );
  }

  // Widget _logoutButton() => Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: ElevatedButton(
  //         style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
  //         onPressed: () => _logout(context),
  //         child: const Text("Logout"),
  //       ),
  //     );
  Widget _actionButton(
    String text,
    Color color,
    VoidCallback onTap, {
    bool bordered = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            elevation: 0,
            side: bordered
                ? BorderSide(color: Colors.grey.shade400)
                : BorderSide.none,
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class AmazonSubHeader extends StatefulWidget {
  const AmazonSubHeader({super.key});

  @override
  State<AmazonSubHeader> createState() => _AmazonSubHeaderState();
}

class _AmazonSubHeaderState extends State<AmazonSubHeader> {
  final List<String> _greetings = [
    "హలో",
    "नमस्ते",
    "Hello",
    "வணக்கம்",
    "नमस्ते"
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Dynamic Language Greeting
          Text(
            _greetings[_currentIndex],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          // Settings Icon
          // IconButton(
          //   icon: const Icon(Icons.settings_outlined, size: 28),
          //   onPressed: () => _showSettingsSheet(context),
          // ),
          // const SizedBox(width: 5),
          // Static Language/Flag Selector
          Row(
            children: [
              Image.network(
                "https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png",
                width: 24,
              ),
              const SizedBox(width: 5),
              const Text("EN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AppSettingsSheet(),
    );
  }
}

// class AmazonHeaderWrapper extends StatelessWidget {
//   const AmazonHeaderWrapper({super.key, });
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//     );
//   }
// }
//
// class AmazonAppBar extends StatelessWidget {
//   const AmazonAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 1,
//       title: const Text(
//         "Amazon",
//         style: TextStyle(color: Colors.black),
//       ),
//       iconTheme: const IconThemeData(color: Colors.black),
//       actions: const [
//         Icon(Icons.search),
//         SizedBox(width: 15),
//         Icon(Icons.shopping_cart_outlined),
//         SizedBox(width: 15),
//       ],
//     );
//   }
// }

// ================= SETTINGS BOTTOM SHEET =================
class AppSettingsSheet extends StatelessWidget {
  const AppSettingsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("App Settings",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 28),
                )
              ],
            ),
          ),
          _buildSettingsTile("Notifications"),
          _buildSettingsTile("Permissions"),
          const Divider(),
          _buildSettingsTile("Default Purchase Settings"),
          _buildSettingsTile("Legal & About"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 15, color: Colors.black87)),
    );
  }
}
