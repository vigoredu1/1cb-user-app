import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/ContactUsScreen.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/OrdersReturnsScreen.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/aboutScreen.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/camcellationPolicy.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/myProfile.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/privacyPolicy.dart';
import 'package:one_click_builder/themes/Nexus/Screens/profile/screens/refundPolicy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  bool isCheckingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
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
      MaterialPageRoute(builder: (_) => NexusSignInScreen()),
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
                MaterialPageRoute(builder: (_) => NexusSignInScreen()),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Account"),
                  _card([
                    _item(context, Icons.person_outline, "My Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileDashboardScreen(),
                        ),
                      );
                    }),
                    _item(context, Icons.shopping_bag_outlined,
                        "Orders & Returns", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrdersReturnScreen(),
                        ),
                      );
                    }),
                  ]),

                  _sectionTitle("Information"),
                  _card([
                    _item(context, Icons.info_outline, "About Us", _aboutUs),
                    _item(context, Icons.cancel_outlined, "Cancellation Policy",
                        _openPolicy),
                    _item(context, Icons.phone_in_talk_outlined, "Contact Us",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactUsScreen(),
                        ),
                      );
                    }),
                    _item(
                        context, Icons.phone_in_talk_outlined, "Refund Policy",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RefundPolicyScreen(),
                        ),
                      );
                    }),
                    _item(
                        context, Icons.phone_in_talk_outlined, "privacy Policy",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      );
                    }),
                  ]),

                  const SizedBox(height: 24),

                  // 🔐 LOGIN BANNER
                  if (!isLoggedIn) _loginBanner(context),

                  // 🔓 LOGOUT BUTTON
                  if (isLoggedIn) _logoutButton(context),
                ],
              ),
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D6D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NexusSignInScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
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
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text("Logout"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () async {
            // Show confirmation dialog
            final shouldLogout = await showDialog<bool>(
              context: context,
              barrierDismissible: false, // user must tap a button
              builder: (ctx) => AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to exit?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );

            // If user confirmed, call your logout function
            if (shouldLogout == true) {
              _logout(context);
            }
          },
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
