import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:one_click_builder/themes/Vector/profile/screens/profile_list_layout.dart';
import 'package:one_click_builder/themes/Vector/utility/svg_assets.dart';

import '../../utility/svg_assets.dart';
import '../../widget/common_statefulwapper.dart';

class ProfileSubLayout extends StatelessWidget {
  const ProfileSubLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> profileList = [
      {
        "id": 1,
        "icon": SvgAssets.iconBox,
        "title": "Order",
        "subtitle": "Ongoing orders, recent orders..",
        "route": "/orderHistory", // 👈 navigation
      },
      {
        "id": 2,
        "icon": SvgAssets.iconWishlistProfile,
        "title": "Wishlist",
        "subtitle": "Your saved products",
        "route": "/wishlist",
      },
      {
        "id": 3,
        "icon": SvgAssets.iconPayment,
        "title": "Payment",
        "subtitle": "Saved cards, wallets",
        "route": "/payment",
      },
      {
        "id": 4,
        "icon": SvgAssets.iconLocation,
        "title": "Save Address",
        "subtitle": "Home, office",
        "route": "/shippingDetails",
      },
      {
        "id": 5,
        "icon": SvgAssets.iconLanguageTranslate,
        "title": "Language",
        "subtitle": "Select your language here",
        "route": "/language",
      },
      {
        "id": 6,
        "icon": SvgAssets.iconCurrency,
        "title": "Currency",
        "subtitle": "Change your currency here",
        "route": "/currency",
      },
      {
        "id": 7,
        "icon": SvgAssets.iconSettings,
        "title": "Setting",
        "subtitle": "RTL, Notification",
        "route": "/setting",
      },
      {
        "id": 8,
        "icon": SvgAssets.iconTermCondition,
        "title": "About Us",
        "subtitle": "T & C for use of platform",
        "route": "/aboutUs",
      },
      {
        "id": 9,
        "icon": SvgAssets.iconTermCondition,
        "title": "Cancellation Policy",
        "subtitle": "T & C for use of platform",
        "route": "/cancelScreen",
      },
      {
        "id": 10,
        "icon": SvgAssets.iconTermCondition,
        "title": "Retrun Policy",
        "subtitle": "T & C for use of platform",
        "route": "/retrunScreen",
      },
      {
        "id": 11,
        "icon": SvgAssets.iconTermCondition,
        "title": "Privacy Policy",
        "subtitle": "T & C for use of platform",
        "route": "/privacyScreen",
      },
      {
        "id": 12,
        "icon": SvgAssets.iconTermCondition,
        "title": "Terms And Condition",
        "subtitle": "T & C for use of platform",
        "route": "/termsCondition",
      },
      {
        "id": 13,
        "icon": SvgAssets.iconHelp,
        "title": "Help",
        "subtitle": "Customer Support, FAQs",
        "route": "/help",
      },
    ];
    // MaterialApp(
    //   routes: {
    //     '/orderHistory': (context) =>  const OrderHistory(),
    //     '/wishlist': (context) => const WishlistScreen(),
    //     '/payment': (context) => const PaymentScreen(),
    //     '/shippingDetails': (context) => const ShippingAddress(),
    //     '/language': (context) => const LanguageScreen(),
    //     '/currency': (context) => const CurrencyScreen(),
    //     '/setting': (context) => const SettingScreen(),
    //     '/termsCondition': (context) => const TermsConditionScreen(),
    //     '/help': (context) => const HelpScreen(),
    //   },
    //   home: const SplashScreen(),
    // );

    return StatefulWrapper(
      //page load event
      onInit: () => Future.delayed(const Duration(milliseconds: 50)),
      // .then((_) => profile.onReady(context)),
      child: Expanded(
        flex: 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // profile list layout
              ...profileList
                  .asMap()
                  .entries
                  .map((e) => ProfileListLayout(
                            index: e.key,
                            data: e.value,
                          )
                      //         .inkWell(
                      //   // onTap: () => profile.onTapList(e.value, context),
                      // ),
                      )
                  ,
            ],
          ),
        ),
      ),
    );
  }
}
