import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/profile/screens/profile_screen.dart';
import 'package:one_click_builder/themes/Vector/utility/svg_assets.dart';
import 'package:one_click_builder/themes/Vector/view/screen/cart/cart_screen.dart';
import 'package:one_click_builder/themes/Vector/view/screen/dashboard_screens/category_screen.dart';
import 'package:one_click_builder/themes/Vector/view/screen/dashboard_screens/wishlist_screen.dart';
import 'package:one_click_builder/themes/Vector/view/screen/home/home_page.dart';
import 'package:svg_flutter/svg.dart';

import '../../../utility/app_theme.dart';
import '../../../utility/svg_assets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> dashboardList = [
    {"icon": SvgAssets.iconHome, "fillIcon": SvgAssets.iconHomeFill},
    {"icon": SvgAssets.iconCategory, "fillIcon": SvgAssets.iconCategoryFill},
    {"icon": SvgAssets.iconDashboardCart, "fillIcon": SvgAssets.iconCartFill},
    {"icon": SvgAssets.iconWishlist, "fillIcon": SvgAssets.iconWishlistFill},
    {
      "icon": SvgAssets.iconDashboardProfile,
      "fillIcon": SvgAssets.iconProfileFill
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePage(),
         CategoryScreen(),
          CartScreen(),
          WishlistScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0, // shadow remove
        currentIndex: selectedIndex,backgroundColor: AppTheme.fromType(
          AppTheme.defaultTheme)
          .whiteColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: List.generate(dashboardList.length, (index) {
          return BottomNavigationBarItem(

            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedIndex == index)
                  Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(height: 3),
                const SizedBox(height: 4),
                SvgPicture.asset(
                  selectedIndex == index
                      ? dashboardList[index]['fillIcon']!
                      : dashboardList[index]['icon']!,
                  height: 24,
                  width: 24,
                ),
              ],
            ),
            label: '',
          )
          ;
        }),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
