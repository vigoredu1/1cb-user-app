import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../utility/app_constant.dart';
import '../../utility/app_theme.dart';
import '../../utility/local_storage.dart';
import '../../widget/common_appbar.dart';

import 'added_pages_model.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  late Future<PageServiceModel?> pageData;

  @override
  void initState() {
    super.initState();
    pageData = getPageContent(AppConstant.retrun_Url); // <- Only change this for other screens
  }

  // ----------- Common API Call for 5 tabs -------------
  Future<PageServiceModel?> getPageContent(String endpoint) async {
    final vendorId = await StorageHelper.getVendorId();
    String url = "${AppConstant.baseUrl}$endpoint$vendorId";

    print("📌 Calling Page API: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return PageServiceModel.fromJson(decoded["data"]);
      } else {
        print("❌ Error Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Page API Exception: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonAppBar(
              appName: "Return Policy",
              isIcon: true,
            ),

            const SizedBox(height: 11),

            Expanded(
              child: FutureBuilder<PageServiceModel?>(
                future: pageData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No content available"));
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Html(data: snapshot.data!.content ?? ""),
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
