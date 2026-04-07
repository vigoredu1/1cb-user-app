import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Wishlist/wishlist.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/ContactUsScreen.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/FlipkartmyProfile.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/OrdersReturnsScreen.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/aboutScreen.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/camcellationPolicy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class FlipkartProfileScreen extends StatefulWidget {
  const FlipkartProfileScreen({super.key});

  @override
  State<FlipkartProfileScreen> createState() => _FlipkartProfileScreenState();
}

class _FlipkartProfileScreenState extends State<FlipkartProfileScreen> {
  bool isLoggedIn = false;
  bool isCheckingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<String> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }

  /// CHECK LOGIN STATUS
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('token');

    setState(() {
      isLoggedIn = userId != null && userId.isNotEmpty;
      isCheckingLogin = false; // ✅ login check completed
    });
  }

  /// LOGOUT
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

    // Delete all active GetX controllers
    //Get.deleteAll(force: true);

    // Optional: Reset entire GetX state (recommended)
    // Get.reset();

    // Navigate to Sign In screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => FlipkartSignInScreen()),
      (route) => false,
    );
  }

  /// LOGIN REQUIRED DIALOG
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

  /// ITEM CLICK HANDLER
  void _handleItemClick(BuildContext context, VoidCallback onSuccess) async {
    if (!isLoggedIn) {
      _showLoginRequiredDialog(context);
      return;
    }
    onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F2FF),
        appBar: AppBar(
          title: const Text("My Account"),
          centerTitle: false,
          elevation: 0,
        ),
        body: isCheckingLogin
            ? Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 120,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     _sectionTitle("Account"),
                //     _card([
                //       _item(context, Icons.person_outline, "My Profile", () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => ProfileDashboardScreen(),
                //           ),
                //         );
                //       }),
                //       _item(context, Icons.shopping_bag_outlined,
                //           "Orders & Returns", () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) =>  OrdersReturnScreen(),
                //           ),
                //         );
                //       }),
                //     ]),

                //     _sectionTitle("Information"),
                //     _card([
                //       _item(context, Icons.info_outline, "About Us", _aboutUs),
                //       _item(context, Icons.cancel_outlined,
                //           "Cancellation Policy", _openPolicy),
                //       _item(context, Icons.phone_in_talk_outlined,
                //           "Contact Us", () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => const ContactUsScreen(),
                //           ),
                //         );
                //       }),
                //     ]),

                //     const SizedBox(height: 24),

                //     // 🔐 LOGIN BANNER
                //     if (!isLoggedIn) _loginBanner(context),

                //     // 🔓 LOGOUT BUTTON
                //     if (isLoggedIn) _logoutButton(context),
                //   ],
                // ),

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _emailCard(),
                      _quickActions(context), // ✅ NEW UI (image style)

                      _sectionTitle("Account"),
                      _card([
                        _item(context, Icons.person_outline, "My Profile", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    FlipkartProfileDashboardScreen()),
                          );
                        }),
                        _item(context, Icons.shopping_bag_outlined,
                            "Orders & Returns", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OrdersReturnScreen()),
                          );
                        }),
                      ]),

                      SizedBox(
                        height: 10,
                      ),

                      if (!isLoggedIn) _loginBanner(context),

                      //    🔓 LOGOUT BUTTON
                      if (isLoggedIn) _logoutButton(context),
                    ]),
              ));
  }

  Widget _emailCard() {
    if (!isLoggedIn) return const SizedBox();

    return FutureBuilder<String>(
      future: _getUserEmail(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.email_outlined, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text("Email",
                      //     style: TextStyle(fontSize: 13, color: Colors.grey)),
                      // const SizedBox(height: 4),
                      Text(
                        snapshot.data!,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.2,
        children: [
          _quickActionItem(
            context,
            Icons.inventory_2_outlined,
            "Orders",
            () {
              _handleItemClick(context, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => OrdersReturnScreen()),
                );
              });
            },
          ),
          _quickActionItem(
            context,
            Icons.card_giftcard_outlined,
            "Wishlist",
            () {
              _handleItemClick(context, () {
                // TODO: Navigate to Coupons screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WishlistScreen()),
                );
              });
            },
          ),
          _quickActionItem(
            context,
            Icons.headset_mic_outlined,
            "Help Center",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactUsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _loginBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C4AB6).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Login to your account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Track orders, manage profile and get personalized offers.",
              style: TextStyle(color: Color(0xFF6B6B6B)),
            ),
            const SizedBox(height: 16),

            /// Login Button (same style as Logout)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlipkartSignInScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE0E0E0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              _logout(context);
            }
          },
          child: const Text(
            "Log Out",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// CARD
  Widget _card(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  /// LIST ITEM
  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _handleItemClick(context, onTap),
        ),

        // 👇 small subtle line
        const Divider(
          height: 0,
          thickness: 0.6,
          indent: 56, // aligns after icon
          endIndent: 12,
          color: Color(0xFFE5E5E5),
        ),
      ],
    );
  }

  void _aboutUs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NexusAboutScreen(),
      ),
    );
  }

  void _openPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CancellationPolicyScreen(),
      ),
    );
  }
}
