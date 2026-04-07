import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_click_builder/themes/Vector/view/screen/cart/cart_screen.dart';
import 'package:one_click_builder/themes/Vector/view/screen/dashboard_screens/category_screen.dart';
import 'package:one_click_builder/themes/Vector/view/screen/home/home_page.dart';
import '../../profile/screens/profile_screen.dart';
import '../../view/screen/dashboard_screens/wishlist_screen.dart';

class DashboardProvider with ChangeNotifier {
  int currentIndex = 0;
  TabController? tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [
    const HomePage(),
    const CategoryScreen(),
    const CartScreen(), // Will open as separate route
    const WishlistScreen(),
    const ProfileScreen()
  ];

  void initTabController(TickerProvider vsync) {
    tabController = TabController(length: pages.length, vsync: vsync);
    currentIndex = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  void changeTab(int index, BuildContext context) {
    if (index == 2) {
      // Cart should open separately
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CartScreen()),
      );
      return;
    }
    _setTab(index);
  }

  void moveTab(BuildContext context, int index, {bool isBack = false}) {
    if (isBack) {
      Navigator.pop(context);
    } else {
      _setTab(index);
    }
  }

  void _setTab(int index) {
    currentIndex = index;
    tabController?.animateTo(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
    notifyListeners();
  }

  Future<void> onBackPress() async {
    if (currentIndex != 0) {
      _setTab(0);
    } else {
      SystemNavigator.pop(); // Exit app
    }
  }
}
