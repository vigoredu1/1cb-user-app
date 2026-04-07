import 'package:flutter/material.dart';

import '../../utility/app_theme.dart';
import '../../widget/common_appbar.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

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
              appName: "Currency",
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
