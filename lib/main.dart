import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:one_click_builder/GlobalSplash/global_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.home,
  });

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'APP_NAME',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      // routes: {
      //   '/orderHistory': (context) => const OrderHistory(),
      //   '/wishlist': (context) => const WishlistScreen(),
      //   '/payment': (context) => PaymentScreen(),
      //   '/shippingDetails': (context) => ShippingDetailsScreen(),
      //   '/language': (context) => const LanguageScreen(),
      //   '/currency': (context) => const CurrencyScreen(),
      //   '/setting': (context) => const SettingScreen(),
      //   '/termsCondition': (context) => const TermsConditionScreen(),
      //   '/retrunScreen': (context) => const ReturnScreen(),
      //   '/cancelScreen': (context) => const CancellationScreen(),
      //   '/aboutUs': (context) => const AboutUsScreen(),
      //   '/privacyScreen': (context) => const PrivacyScreen(),
      //   '/help': (context) => const HelpScreen(),
      // },
      home: home ?? const GlobalSplash(),
    );
  }
}
