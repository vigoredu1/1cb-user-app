import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Category/CategoryUIController.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Plugin/plugin.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Search/searchControllers.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/cart_controller.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/guestCartController/guestCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/BottomNavCategory/bottoNavCategory.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Cart/AmzCart.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/home.dart';
import 'package:one_click_builder/themes/Amazon/Screens/SearchScreren/AmzSearchScreen.dart';
import 'package:one_click_builder/themes/Amazon/Screens/profile/screens/AmzProfileScreen.dart';
import 'package:one_click_builder/themes/Amazon/utility/app_theme.dart';
import '../Controllers/profile/profileController.dart';
import '../utility/plugin_list.dart';

class AmzMain extends StatefulWidget {
  const AmzMain({super.key});

  @override
  State<AmzMain> createState() => _AmzMainState();
}

class _AmzMainState extends State<AmzMain> {
  int _selectedIndex = 0;
  bool _showSplash = true;

  final TextEditingController searchTextCtrl = TextEditingController();
  final NexusSearchController searchCtrl =
  Get.put(NexusSearchController(), permanent: true);
final PluginController pluginController = Get.put(PluginController());
  DateTime? lastBackPressed;

  /// 🔥 Pages (order same rakho)
  final List<Widget> _pages = [
    const AmzHome(),
    const ProfileScreen(),
    AmzCartScreen(),
    const AllCategoriesScreen(), // Menu ke liye (change later)
  ];

  final AmzVendorController vendorCtrl =
  Get.find<AmzVendorController>();

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() async {
    final prefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(prefs, permanent: true);
      pluginController.fetchPlugins(vendorCtrl.vendorId.value);


    Get.put(GuestCartController(), permanent: true);
    Get.put(ProfileOrdersController(), permanent: true);
    Get.put(CategoryUIController(), permanent: true);

    final cartCtrl = Get.put(AmzCartController(), permanent: true);

    vendorCtrl.loadVendorFromStorage().then((_) async {
      final vendorId = vendorCtrl.vendorId.value;
      if (vendorId.isNotEmpty) {
        await cartCtrl.checkLogin(vendorId);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 5)) {
      lastBackPressed = now;
      Get.snackbar(
        'Exit App',
        'Press again to exit',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('')),
      );
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Theme(
        data: AmzTheme(),
        child: Scaffold(
          appBar: _buildSearchBar(),
          body: _pages[_selectedIndex],
          bottomNavigationBar: _amazonBottomBar(),
        ),
      ),
    );
  }

  /// 🔍 APP BAR
  PreferredSizeWidget _buildSearchBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchTextCtrl,
          onSubmitted: (v) async {
            if (v.trim().isEmpty) return;
            searchCtrl.searchProduct(v);
            await Get.to(() => const SearchScreen());
            searchTextCtrl.clear();
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            hintText: "Search here...",
          ),
        ),
      ),
    );
  }

  /// 🔥 AMAZON BOTTOM BAR (TOP INDICATOR)
  Widget _amazonBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, "Home", 0),
            _navItem(Icons.person_outline, "You", 1),
            _navItem(Icons.shopping_cart_outlined, "Cart", 2, badge: true),
            _navItem(Icons.menu_outlined, "Menu", 3),
          ],
        ),
      ),
    );
  }

  /// 🔥 SINGLE ITEM WITH TOP LINE
  Widget _navItem(
      IconData icon,
      String label,
      int index, {
        bool badge = false,
      }) {
    final isActive = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 6,
              width: isActive ? 45 : 0,
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
            Stack(
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: Colors.black,
                ),
                // if (badge)
                //   Positioned(
                //     right: -6,
                //     top: -6,
                //     child: Container(
                //       padding: const EdgeInsets.all(4),
                //       decoration: const BoxDecoration(
                //         color: Colors.black,
                //         shape: BoxShape.circle,
                //       ),
                //       child: const Text(
                //         "5",
                //         style: TextStyle(
                //           fontSize: 10,
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
