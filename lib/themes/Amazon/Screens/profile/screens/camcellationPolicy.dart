import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';
import 'package:one_click_builder/themes/Amazon/Modules/profile/AmzCancellationPolicy.dart';
import 'package:one_click_builder/themes/Amazon/api/profile/cancellationPolicy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CancellationPolicyScreen extends StatefulWidget {
  const CancellationPolicyScreen({super.key});

  @override
  State<CancellationPolicyScreen> createState() =>
      _CancellationPolicyScreenState();
}

class _CancellationPolicyScreenState extends State<CancellationPolicyScreen> {
  bool isLoading = true;
  CancellationPolicyData? policy;
  String vendorId = "";

  @override
  void initState() {
    super.initState();
    loadVendorAndPolicy();
  }

  /// Load vendor ID + call API
  Future<void> loadVendorAndPolicy() async {
    try {
      setState(() => isLoading = true);

      /// 🔹 Fetch vendor ID from SharedPreferences (instead of controller)
      final prefs = await SharedPreferences.getInstance();
      vendorId = prefs.getString('vendor_id') ?? '';

      if (vendorId.isEmpty) {
        print("❌ Vendor ID not found in storage");
        return;
      }

      /// 🔹 Direct API Call
      policy = await CancellationPolicyService.fetchPolicy(vendorId);

    } catch (e) {
      debugPrint("Error fetching policy: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Policy'),
      ),
      body: isLoading
          ? Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 200,
                  height: 20,
                  color: Colors.white,
                ),
              ),
            )
          : policy == null
              ? const Center(child: Text("No policy available"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Html(
                    data: policy!.content ?? "",
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "p": Style(
                        fontSize: FontSize(16),
                        lineHeight: LineHeight(1.6),
                        margin: Margins.only(bottom: 12),
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,
                      ),
                    },
                  ),
                ),
    );
  }
}
