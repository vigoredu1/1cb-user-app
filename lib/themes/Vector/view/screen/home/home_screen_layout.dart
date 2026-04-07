import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/data/notification/notification_screen.dart';
import 'package:one_click_builder/themes/Vector/utility/svg_assets.dart';

import '../../../controller/homepage/product_list_provider.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/plugin_list.dart';
import '../search/product_search_screen.dart';

class HomeScreenLayout extends StatelessWidget {
  const HomeScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final productController =
        Provider.of<ProductListController>(context, listen: false);

    return Column(
      children: [
        Container(
          height: 42,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
          color: AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.fromType(AppTheme.defaultTheme).colorContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.fromType(AppTheme.defaultTheme)
                              .primaryColor
                              .withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.fromType(AppTheme.defaultTheme).shadowColorThree,
                            spreadRadius: 2,
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.iconMenu,
                          fit: BoxFit.scaleDown,
                          height: 20,
                          width: 20,
                          color: AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 🔔 Notification button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
                  );                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.fromType(AppTheme.defaultTheme).colorContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.fromType(AppTheme.defaultTheme)
                          .primaryColor
                          .withOpacity(0.1),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.fromType(AppTheme.defaultTheme).shadowColorThree,
                        spreadRadius: 2,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      SvgAssets.iconTopNotification,
                      fit: BoxFit.scaleDown,
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductSearchScreen()
              ),
            );
          },
          child: Row(children: [
            const SizedBox(
              width: 12,
            ),
            Expanded(
                flex: 5,
                child: Container(
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground
                  ),
                  height: 48,
                  child:  Row(
                    children: [
                      const SizedBox(
                        width: 18,
                      ),
                            SvgPicture.asset(
                              SvgAssets.iconSearch,
                              fit: BoxFit.scaleDown,
                            ),const SizedBox(
                        width: 18,
                      ),
                      Text('Search On Vector Theme..',style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppTheme.fromType(AppTheme.defaultTheme)
                                      .primaryColor
                                      .withOpacity(0.34)),)
                    ],
                  )
                  // TextFormField(
                  //   // validator: validator,
                  //   // keyboardType: keyboardType,
                  //   // focusNode: focusNode,
                  //   decoration: InputDecoration(
                  //       fillColor: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
                  //       filled: true,
                  //       isDense: true,
                  //       //input border
                  //       disabledBorder: const OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(6)),
                  //           borderSide: BorderSide.none),
                  //       focusedBorder: const OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(6)),
                  //           borderSide: BorderSide.none),
                  //       enabledBorder: const OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(6)),
                  //           borderSide: BorderSide.none),
                  //       border: const OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(6)),
                  //           borderSide: BorderSide.none),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 10, vertical: 10),
                  //       prefixIcon:
                  //       SvgPicture.asset(
                  //         SvgAssets.iconSearch,
                  //         fit: BoxFit.scaleDown,
                  //       ),
                  //       hintStyle: TextStyle(
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 14,
                  //           color: AppTheme.fromType(AppTheme.defaultTheme)
                  //               .primaryColor
                  //               .withOpacity(0.34)),
                  //       hintText: 'Search Here'),
                  //   controller: productController.searchController,
                  // ),
                )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                    // onTap: onPressed,
                    child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.fromType(AppTheme.defaultTheme)
                              .searchBackground,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                            child: SvgPicture.asset(
                          SvgAssets.iconFilter,
                          fit: BoxFit.scaleDown,
                          colorFilter: ColorFilter.mode(
                              AppTheme.fromType(AppTheme.defaultTheme)
                                  .primaryColor,
                              BlendMode.srcIn),
                          height: 20,
                          width: 20,
                        )))),
              ),
            )
          ]),
        )
      ],
    );
  }
}
