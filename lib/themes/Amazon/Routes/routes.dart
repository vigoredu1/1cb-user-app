import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/Category/allCategories.dart';


class NexusAppRoutes {
  /// ROUTE NAMES
  static const String home = '/home';
  static const String categories = '/categories';
  static const String account = '/account';
  static const String productDetails = '/product-details';

  /// ROUTE MAP
  static Map<String, WidgetBuilder> get routes => {
      //  home: (context) => const HomeScreen(),
        categories: (context) => const AllCategoriesScreen(),
       // account: (context) => const AccountScreen(),
      //  productDetails: (context) => const ProductDetailsScreen(),
      };
}
