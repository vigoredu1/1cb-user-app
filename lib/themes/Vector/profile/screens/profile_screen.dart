import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/profile/screens/profile_appbar_layout.dart';
import 'package:one_click_builder/themes/Vector/profile/screens/profile_edit_screen.dart';
import 'package:one_click_builder/themes/Vector/utility/svg_assets.dart';
import 'package:one_click_builder/themes/Vector/widget/common_statefulwapper.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../controller/userprofile_provider.dart';
import '../../core_widget/common_button.dart';
import '../../utility/app_theme.dart';
import '../../utility/images.dart';
import '../../utility/svg_assets.dart';
import '../../view/screen/authentication/login/layout/login_image.dart';
import '../../view/screen/authentication/login/login_page.dart';
import '../widgets/features_list_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // If user is not logged in, show login prompt
    // if (userProvider.userResponse == null) {
    //   return Scaffold(
    //     body: Center(
    //         child: Column(
    //       // mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         // const LoginImage(),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         const Text(
    //           "Currently you are not login",
    //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //         ),
    //         const SizedBox(
    //           height: 30,
    //         ),
    //         CommonButton(
    //             onTap: () {
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => const LoginPage()));
    //             },
    //             buttonText: "Sign in")
    //       ],
    //     )),
    //   );
    // }

    // If user is logged in, show profile
    return StatefulWrapper(
      onInit: () => Future.delayed(const Duration(milliseconds: 50)),
      child: PopScope(
        canPop: true,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor:
                AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
            body: SafeArea(
                child: Stack(children: [
              const ProfileAppbarLayout(),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.075,
                    ),
                    height: 90,
                    width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45), // make it circular
                      child: (userProvider.userResponse?.user.profilePicture != null &&
                          userProvider.userResponse!.user.profilePicture!.isNotEmpty)
                          ? Image.network(
                        "${userProvider.userResponse!.user.profilePicture}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(Images.ProfilePic, fit: BoxFit.cover);
                        },
                      )
                          : Image.asset(
                        Images.ProfilePic, // fallback if null/empty
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )

                // .paddingSymmetric(
                // vertical: Insets.i5, horizontal: Insets.i20)
              ]),
              Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.107),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(
                                    left: 105.0
                                ),
                            child: Text(
                                "${userProvider.userResponse?.user.firstName ?? ""} \n ${userProvider.userResponse?.user.lastName ?? ""}",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color:
                                        AppTheme.fromType(AppTheme.defaultTheme)
                                            .primaryColor),maxLines: 2
                              ,),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileSettingScreen()),
                              );
                            },
                            child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          AppTheme.fromType(AppTheme.defaultTheme)
                                              .primaryColor
                                              .withOpacity(0.07),
                                    ),
                                    color:
                                        AppTheme.fromType(AppTheme.defaultTheme)
                                            .whiteColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTheme.fromType(
                                                  AppTheme.defaultTheme)
                                              .shadowColorThree,
                                          spreadRadius: 2,
                                          blurRadius: 8)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SvgPicture.asset(
                                    SvgAssets.iconEdit,
                                    color:
                                        AppTheme.fromType(AppTheme.defaultTheme)
                                            .primaryColor,
                                  ),
                                )
                                // .paddingAll(Insets.i5)
                                ),
                          )
                        ]),
                  )
                  // .paddingSymmetric(horizontal: Insets.i20)
                  ),

            ])),
          ),
        ),
      ),
    );
  }
}
