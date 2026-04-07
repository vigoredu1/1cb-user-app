import 'package:flutter/material.dart';

import '../../utility/app_theme.dart';
import '../../widget/common_appbar.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
                appName: "language",
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
