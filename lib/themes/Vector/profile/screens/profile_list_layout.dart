import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../../utility/app_theme.dart';

class ProfileListLayout extends StatelessWidget {
  final int index;
  final dynamic data;

  const ProfileListLayout({super.key, this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (data['route'] != null) {
          Navigator.pushNamed(context, data['route']);
        }
        // OR agar direct screen chahiye to:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => HelpScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    data['icon'],
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'].toString(),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        data['subtitle'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: AppTheme.fromType(AppTheme.defaultTheme).lightText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                height: 2,
                color: AppTheme.fromType(AppTheme.defaultTheme).colorDivider,
              ),
            )
          ],
        ),
      ),
    );
  }
}
