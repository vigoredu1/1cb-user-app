import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/cart_controller.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartControllers/product/productController.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/plugin/plugin.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Cart/flipkartCart.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/home.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/flipkartProfileScreen.dart';
import 'package:one_click_builder/themes/Fuzzy/utility/plugin_list.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/BottomNavCategory/bottoNavCategory.dart';
import 'package:one_click_builder/themes/Flipkart/utility/app_theme.dart';

class FlipkartMain extends StatefulWidget {
  const FlipkartMain({super.key});

  @override
  State<FlipkartMain> createState() => _FlipkartMainState();
}

class _FlipkartMainState extends State<FlipkartMain> {
  int _selectedIndex = 0;
  bool _showSplash = true;
  final TextEditingController searchTextCtrl = TextEditingController();
  late FlipkartSearchController searchCtrl;
final PluginController pluginController = Get.put(PluginController());
  DateTime? lastBackPressed;

  /// ✅ Pages
  final List<Widget> _pages = [
    const FlipkartHome(),
    const AllCategoriesScreen(),
    const FlipkartProfileScreen(),
    FlipkartCartScreen(),
  ];
  late FlipkartVendorController vendorCtrl;

  /// ✅ GetX Controllers (GLOBAL)
  ///
  @override
  void initState() {
    super.initState();

    print('flipkart main called');
    initializeControllers(); // async setup
  }

  Future<void> initializeControllers() async {
    final prefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(prefs, permanent: true);

    Get.put(GuestCartController(), permanent: true);

    // ✅ PUT FIRST
    vendorCtrl = Get.put(FlipkartVendorController(), permanent: true);
    Get.put(ProductController(), permanent: true);


    // ✅ FIND AFTER PUT
    searchCtrl = Get.put(FlipkartSearchController(), permanent: true);
    Get.put(FlipkartCategoryUIController(), permanent: true);
    final cartCtrl = Get.put(CartController(), permanent: true);

    await vendorCtrl.loadVendorFromStorage();
    pluginController.fetchPlugins(vendorCtrl.vendorId.value);

    final vendorId = vendorCtrl.vendorId.value;
    if (vendorId.isNotEmpty) {
      await cartCtrl.checkLogin(vendorId);
    }

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 5)) {
      lastBackPressed = now;

      // Show warning
      Get.snackbar(
        'Exit App',
        'Press again to exit',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Do not exit yet
    }
    return true; // Exit app
  }

  /// ✅ LOGIC:
  /// Logged in → SharedPreferences
  /// Not logged in → Existing Nexus controller value

  @override
  void dispose() {
    searchTextCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 🔥 SPLASH SCREEN
   if (_showSplash) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        // 🔥 Background Splash Image
        SizedBox.expand(
          child: Image.asset(
            'assets/splash.png',
            fit: BoxFit.fill,
          ),
        ),

        // 🔥 App Logo in Center
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Center(
            child: Image.asset(
              'assets/brand_logo.jpg',
              width: 220, // adjust if needed
            //  height: 220,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  );
}

    /// 🔥 MAIN APP UI (Bottom Nav)
    return WillPopScope(
      onWillPop: onWillPop,
      child: Theme(
        data: nexusTheme(),
        child: Scaffold(
        backgroundColor: Colors.white,
          body: _pages[_selectedIndex],
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                elevation: 0,
                selectedItemColor: const Color(0xFF2874F0),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                showUnselectedLabels: true,
                items: [
                  /// HOME
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded, size: 28),
                    label: "Home",
                  ),

                  /// CATEGORIES
                  BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_rounded, size: 26),
                    label: "Categories",
                  ),

                  /// ACCOUNT
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 28),
                    label: "Account",
                  ),

                  /// CART WITH BADGE
                  BottomNavigationBarItem(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 28),

                       
                      ],
                    ),
                    label: "Cart",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
