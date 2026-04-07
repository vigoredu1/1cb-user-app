import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/BestSellerScreen/nexusBestSeller.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/Category/CategoryList.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/NexusProduct/nexusNewArrival.dart';
import 'package:one_click_builder/themes/Nexus/Screens/Home/banners.dart';
import 'package:one_click_builder/themes/Nexus/api/BestSeller/NexusBestSeller.dart';
import 'package:one_click_builder/themes/Nexus/api/Categoryalist/categoryList.dart';
import 'package:one_click_builder/themes/Nexus/api/NexusProduct/nexusProduct.dart';
import 'package:one_click_builder/themes/Nexus/api/banners/bannersApi.dart';


class NexusHome extends StatefulWidget {
  const NexusHome({super.key});

  @override
  State<NexusHome> createState() => _NexusHomeState();
}

class _NexusHomeState extends State<NexusHome> {
  final bannerApi = NexusBannerApiService();
  final categoryApi = NexusCategoryApiService();
  final newApi = ProductService();
  final bestApi = BestSellerService();
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<NexusVendorController>()) {
      Get.put(NexusVendorController(), permanent: true);
    }
  }

 Future<void> _refreshHome() async {
    final vendorId = Get.find<NexusVendorController>().vendorId.value;

    print("🔄 Pull-to-Refresh: Fetching all Home APIs again…");

    await bannerApi.getBannerList(vendorId);

    await categoryApi.fetchCategories(vendorId);
    //await newApi.getProducts(vendorId);
    await bestApi.getBestSellerProducts(vendorId);

    // UI will refresh itself since data updates inside widgets
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        color: Colors.blue, // optional
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              BannerScreen(),
              const SizedBox(height:20),
              NexusCategoryScreen(),
             // const SizedBox(height:20),
              NewArrivalSection(),
              const SizedBox(height:20),
              BestSellerScreen(),
                        const SizedBox(height: 10)
            //  const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
