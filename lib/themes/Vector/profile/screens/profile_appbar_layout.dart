import 'package:flutter/cupertino.dart';
import 'package:one_click_builder/themes/Vector/profile/screens/profile_sub_layout.dart';

import '../../utility/app_theme.dart';

class ProfileAppbarLayout extends StatelessWidget {
  const ProfileAppbarLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 102,
        width: MediaQuery.of(context).size.width,
        color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Profile',
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
        ),
        //profile list of layout
      ),
      const SizedBox(
        height: 35,
      ),
      const ProfileSubLayout()
    ]);
  }
}
