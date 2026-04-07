import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../../utility/app_theme.dart';
import '../../utility/svg_assets.dart';
import '../../view/screen/search/product_search_screen.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
        body: Column(
          children: [
            SizedBox(height: 8,),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Order History',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.fromType(AppTheme.defaultTheme).primaryColor),
                ),
              ),
              //     .paddingOnly(top: Insets.i8))
              // .paddingSymmetric(horizontal: Insets.i20)
              // .paddingOnly(top: Insets.i10)
            ),            SizedBox(height: 10,),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProductSearchScreen()
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
                            Text('Search here..',style: TextStyle(
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
            ),
            SizedBox(height: 200,),
            Text('No Order found..',style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppTheme.fromType(AppTheme.defaultTheme)
                    .primaryColor
                    .withOpacity(0.34)),)

          ],
        ),
      ),
    );
  }
}
