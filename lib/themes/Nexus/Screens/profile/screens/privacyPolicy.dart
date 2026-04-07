import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late Future<String> _privacyFuture;

  // 🔥 Get vendor controller
  final NexusVendorController vendorController =
      Get.find<NexusVendorController>();

  @override
  void initState() {
    super.initState();
    _privacyFuture = fetchPrivacyPolicy();
  }

  Future<String> fetchPrivacyPolicy() async {
    final vendorId = vendorController.vendorId.value;

    if (vendorId.isEmpty) {
      throw Exception('Vendor ID not available');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse(
        'https://api.1clickbuilder.com/api/page-service/privacy/$vendorId',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': token,
        // use Bearer if backend requires
        // 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['data']?['content'] ?? '';
    } else {
      throw Exception(
        'Failed to load privacy policy (${response.statusCode})',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _privacyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Html(
              data: snapshot.data ?? '',
              style: {
                "body": Style(
                  fontSize: FontSize(15),
                  lineHeight: const LineHeight(1.6),
                ),
                "h2": Style(
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.bold,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
