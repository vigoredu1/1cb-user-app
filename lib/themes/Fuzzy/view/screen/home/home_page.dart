// import 'package:flutter/material.dart';
// import 'package:one_click_builder/controller/authentication/login_provider.dart';
// import 'package:one_click_builder/utility/local_storage.dart';
// import 'package:one_click_builder/view/screen/home/home_screen_layout.dart';
// import 'package:one_click_builder/view/screen/home/logo_display.dart';
// import 'package:one_click_builder/view/screen/home/new_arrivals.dart';
// import 'package:one_click_builder/view/screen/home/whatsnew_page.dart';
// import 'package:one_click_builder/view/screen/product_detail/product_wigdet_item.dart';
// import 'package:provider/provider.dart';
//
// import '../../../controller/cart/cart_controller.dart';
// import '../../../controller/homepage/banner_provider.dart';
// import '../../../controller/homepage/category_provider.dart';
// import '../../../controller/homepage/product_provider.dart';
// import '../../../controller/userprofile_provider.dart';
// import '../../../core_widget/appdrawer.dart';
// import '../../../data/model/home/category_model.dart';
// import '../../../utility/app_theme.dart';
// import '../banner/banner_image_widget.dart';
// import '../banner/banner_url_widget.dart';
// import '../search/product_search_screen.dart';
// import 'explore_collections_widget.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//   @override
//   _HomePageState createState() => _HomePageState();
// }
// class _HomePageState extends State<HomePage> {
//   Category? selectedCategory;
//   String? LogoUrl;
//
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//   GlobalKey<RefreshIndicatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // load logo from local storage
//     loadLogo();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _refreshIndicatorKey.currentState?.show();
//     });
//   }
//
//   void loadLogo() async {
//     final url = await StorageHelper.getLogoUrl();
//     setState(() {
//       LogoUrl = url;
//     });
//   }
//
//   Future<void> _refreshData() async {    await Provider.of<UserProvider>(context, listen: false).loadUserData();
//   await Provider.of<BannerProvider>(context, listen: false).loadBanners();
//
//   await Provider.of<LoginProvider>(context, listen: false).fetchLogoData();
//     await Provider.of<CategoryProvider>(context, listen: false).loadCategories();
//     await Provider.of<ProductProvider>(context, listen: false).loadAllProducts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final banner = Provider.of<BannerProvider>(context).banners.isNotEmpty
//         ? Provider.of<BannerProvider>(context).banners.first
//         : null;
//     final categoryProvider = Provider.of<CategoryProvider>(context);
//
//     if (selectedCategory == null && categoryProvider.categories.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           selectedCategory = categoryProvider.categories[0];
//         });
//       });
//     }
//
//     return Scaffold(
//       backgroundColor:
//       AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
//       drawer: const CustomDrawer(),
//       body: SafeArea(
//         child: RefreshIndicator(
//           key: _refreshIndicatorKey,color: AppTheme.fromType(
//             AppTheme.defaultTheme)
//             .primaryColor,
//           onRefresh: _refreshData,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const HomeScreenLayout(),
//                 banner == null
//                     ? const Text(
//                   'Loading.....',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 )
//                     : BannerUrlCard(banner: banner),
//                 const WhatsNew(),
//                 const SizedBox(height: 10),
//                 const NewArrivals(),
//                 const SizedBox(height: 20),
//                 const ExploreCollectionWidget(),
//                 const SizedBox(height: 15),
//                 const SizedBox(height: 30),
//                 AllBannerImagesList(
//                   banners: Provider.of<BannerProvider>(context).banners,
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Fuzzy/view/screen/home/whatsnew_page.dart';

import 'package:provider/provider.dart';

import '../../../controller/authentication/login_provider.dart';
import '../../../controller/cart/cart_controller.dart';
import '../../../controller/homepage/banner_provider.dart';
import '../../../controller/homepage/category_provider.dart';
import '../../../controller/homepage/product_list_provider.dart';
import '../../../controller/homepage/product_provider.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../core_widget/appdrawer.dart';
import '../../../data/model/home/category_model.dart';
import '../../../service/home/best_selling_product_api.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/local_storage.dart';
import '../banner/banner_image_widget.dart';
import '../banner/banner_url_widget.dart';
import 'explore_collections_widget.dart';
import 'home_screen_layout.dart';
import 'new_arrivals.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Category? selectedCategory;
  String? logoUrl;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    // ✅ load logo from local storage
    loadLogo();

    // ✅ ensure refresh runs after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void loadLogo() async {
    final url = await StorageHelper.getLogoUrl();
    setState(() {
      logoUrl = url;
    });
  }

  Future<void> _refreshData() async {
    try {
      // agar screen abhi tak mounted nahi hai, to kuch mat karo
      if (!mounted) return;

      await Provider.of<LoginProvider>(context, listen: false).fetchLogoData();
      if (!mounted) return;

      await Provider.of<BannerProvider>(context, listen: false).loadBanners();
      if (!mounted) return;

      await Provider.of<CategoryProvider>(context, listen: false).loadCategories();
      if (!mounted) return;

      await Provider.of<ProductProvider>(context, listen: false).loadAllProducts();
      if (!mounted) return;
      await Provider.of<BestSellingProductProvider>(context, listen: false)
          .fetchBestSellerProducts();
      await Provider.of<ProductListController>(context, listen: false)
          .loadProducts();
      await Provider.of<UserProvider>(context, listen: false).loadUserData();
    } catch (e) {
      debugPrint("❌ HomePage refresh error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final banner = Provider.of<BannerProvider>(context).banners.isNotEmpty
        ? Provider.of<BannerProvider>(context).banners.first
        : null;

    final categoryProvider = Provider.of<CategoryProvider>(context);

    if (selectedCategory == null && categoryProvider.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedCategory = categoryProvider.categories[0];
        });
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const HomeScreenLayout(),

                banner == null
                    ? const Text(
                  'Loading.....',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
                    : BannerUrlCard(banner: banner),

                const WhatsNew(),
                const SizedBox(height: 10),
                const NewArrivals(),
                const SizedBox(height: 20),
                const ExploreCollectionWidget(),
                const SizedBox(height: 15),
                const SizedBox(height: 30),

                AllBannerImagesList(
                  banners: Provider.of<BannerProvider>(context).banners,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _HomePageState extends State<HomePage> {
//   Category? selectedCategory;
//   // late Future<Data> _futureLogo;
//   bool isLoading = true;
//   String? LogoUrl;
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<LoginProvider>(context, listen: false).fetchLogoData();
//     final controller = Provider.of<CartController>(context, listen: false);
//
//     loadLogo();
//
//     // Future.delayed(Duration.zero, () {
//     //   Provider.of<CategoryProvider>(context, listen: false).loadCategories();
//     //   Provider.of<ProductProvider>(context, listen: false).loadAllProducts();
//     //   Provider.of<BannerProvider>(context, listen: false).loadBanners();
//     //   Provider.of<UserProvider>(context, listen: false).loadUserData();
//     // });
//   }
//
//   void loadLogo() async {
//     final url = await StorageHelper.getLogoUrl();
//     setState(() {
//       LogoUrl = url;
//     });
//   }
//
//   Future<void> _refreshData() async {
//     await Provider.of<LoginProvider>(context, listen: false).fetchLogoData();
//     await Provider.of<CategoryProvider>(context, listen: false)
//         .loadCategories();
//     await Provider.of<ProductProvider>(context, listen: false)
//         .loadAllProducts();
//     await Provider.of<BannerProvider>(context, listen: false).loadBanners();
//     await Provider.of<UserProvider>(context, listen: false).loadUserData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final banner = Provider.of<BannerProvider>(context).banners.isNotEmpty
//         ? Provider.of<BannerProvider>(context).banners.first
//         : null;
//     final categoryProvider = Provider.of<CategoryProvider>(context);
//     final productProvider =
//         Provider.of<ProductProvider>(context, listen: false);
//
//     if (selectedCategory == null && categoryProvider.categories.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           selectedCategory = categoryProvider.categories[0];
//         });
//       });
//     }
//     return Scaffold(
//       backgroundColor:
//           AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: _refreshData,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const HomeScreenLayout(),
//                 banner == null
//                     ?
//                 const Text(
//                         'Loading.....',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       )
//                     : BannerUrlCard(banner: banner),
//                 const WhatsNew(),
//
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const ItemWidget(),
//                 // const ProductWidgetItem(),
//                 const SizedBox(
//                   height: 20,
//                 ),
//
//                 const ExploreCollectionWidget(),
//                 const SizedBox(
//                   height: 15,
//                 ),
//
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 AllBannerImagesList(
//                     banners: Provider.of<BannerProvider>(context).banners),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
