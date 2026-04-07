import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../../utility/app_theme.dart';
import '../../utility/svg_assets.dart';
import '../../widget/common_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "icon":  SvgAssets.iconDiscount,
        "title": "30% Special Discount!",
        "subtitle": "Social promotion only valid today",
      },
      {
        "icon":  SvgAssets.iconWallet,
        "title": "Top up E-wallet successful",
        "subtitle": "You have to top up your wallet",
      },
      {
        "icon":  SvgAssets.iconLocation,
        "title": "New service Available",
        "subtitle": "Now you can track orders",
      },
      {
        "icon":   SvgAssets.iconCard,
        "title": "Credit card connected!",
        "subtitle": "Credit card has been linked!",
      },
      {
        "icon":   SvgAssets.iconProfile,
        "title": "Account setup successful!",
        "subtitle": "Your account has been created!",
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.fromType(
          AppTheme.defaultTheme)
          .backGroundColorMain,
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: const Text(
      //     "Notification",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.black,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: SafeArea(

        child: Column(
          children: [
            CommonAppBar(
              appName: "Notification",
              isIcon: true,
            ),
            SizedBox(
              height: 11,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return Container(
                    // padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: AppTheme.fromType(
                            AppTheme.defaultTheme)
                            .searchBackground),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 4,),
                        // SVG Icon
                        Container(
                          height: 45,
                          width: 45,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                              color: AppTheme.fromType(
                                  AppTheme.defaultTheme)
                                  .colorContainer),
                          child: SvgPicture.asset(
                            item["icon"]!,
                            fit: BoxFit.scaleDown,

                            // height: 28,
                            // width: 28,
                            // color: Colors.black87,
                          ),
                        ),
                        // const SizedBox(width: 12),
        
                        // Texts
                        Expanded(
                          flex: 3,
                          child: Padding(

                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"]!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  item["subtitle"]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.fromType(
                                        AppTheme.defaultTheme)
                                        .lightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
