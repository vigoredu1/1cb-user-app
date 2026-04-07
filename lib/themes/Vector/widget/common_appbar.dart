import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../utility/app_theme.dart';
import '../utility/svg_assets.dart';

class CommonAppBar extends StatelessWidget {
  final bool isIcon;
  final String appName;
  // final VoidCallback? onPressed;
  final EdgeInsetsGeometry? margin;

  const CommonAppBar({
    super.key,
    this.isIcon = false,
    required this.appName,
    // this.onPressed,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {

        return Stack(
          children: [
            (isIcon == true)
                ? IconButton(
              icon: SvgPicture.asset(
                isIcon
                    ? SvgAssets.iconBackArrow  // RTL
                    : SvgAssets.iconNextArrow, // LTR
                colorFilter: ColorFilter.mode(
                  AppTheme.fromType(
                      AppTheme.defaultTheme)
                      .primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            )
                : const SizedBox(width: 36),

            // ✅ Title center aligned
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    appName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.fromType(AppTheme.defaultTheme)
                            .primaryColor),
                  ),
                )),      SizedBox(
              height: 11,
            ),
          ],
        );

  }
}
