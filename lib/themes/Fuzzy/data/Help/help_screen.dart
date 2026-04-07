import 'package:flutter/material.dart';

import '../../utility/app_theme.dart';
import '../../widget/common_appbar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fromType(
          AppTheme.defaultTheme)
          .backGroundColorMain,
      body: SafeArea(

        child: Column(
          children: [
            CommonAppBar(
              appName: "Help & Support",
              isIcon: true,
            ),
            SizedBox(
              height: 11,
            ),],
        ),
      ),
    );
  }
}
