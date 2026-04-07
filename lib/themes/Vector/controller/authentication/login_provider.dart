import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Vector/controller/dashboard/dashboard_provider.dart';
import 'package:one_click_builder/themes/Vector/data/model/vendor_id_model.dart';
import 'package:one_click_builder/themes/Vector/view/screen/dashboard_screens/dashboard.dart';
import 'package:provider/provider.dart';

import '../../utility/app_constant.dart';
import '../../utility/local_storage.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool isNewPassword = true;
  bool checkedValue = false, isBack = false;

//login button
  onLogin(context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (loginKey.currentState!.validate()) {
      LoginUser(context);
      // login(context);
    }
  }

  // LoginUser api function(
  Future<void> LoginUser(BuildContext context) async {
    final url = Uri.parse("${AppConstant.baseUrl}${AppConstant.loginUrl}");
    final Map<String, dynamic> requestBody = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      final responseData =
          jsonDecode(response.body); // Convert response body to JSON

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        String token = responseData['data']['token']; // Token extract
        await StorageHelper.saveToken(token); // Token store using helper

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Congrats! login"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,

          ),
        );
        login(context);
      } else {
        print(responseData['error']['message']);
        print("Error: ${response.statusCode}, ${response.body}");

        //  Show API Error Message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                responseData['error']['message'] ?? "Login failed! Try again."),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,

          ),
        );
      }
    } catch (e) {
      print("Exception: $e");
      print("Exception: $e");

      //  Internet or Server Error Message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong! Check your internet."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
// >>>>>>> origin/shubham
        ),
      );
    }
  }

//page load
  onReady(context) {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    isBack = data ?? false;
  }

  //login
  login(context) {
    if (isBack) {
      print("Back");
    } else {
      print("Home screen");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => DashboardProvider()),
            ],
            child:
                const DashboardScreen(), // Yahan HomeScreen ya Dashboard widget pass karein.
          ),
        ),
        (Route<dynamic> route) =>
            false, // Sabhi previous routes ko remove kare.
      );
    }

    notifyListeners();
    onBack();
  }

//onBack clear
  onBack() {
    emailController.text = "";
    passwordController.text = "";
    notifyListeners();
  }

  //new password see tap
  newPasswordSeenTap() {
    isNewPassword = !isNewPassword;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<VendorIdModel> fetchLogoData() async {
    final response = await http.get(
      Uri.parse(AppConstant.baseUrl + AppConstant.vendorIdURl),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final nestedData = jsonBody['data'];

      await StorageHelper.saveVendorId(nestedData['vendorId']);
      await StorageHelper.saveLogoUrl(nestedData['logoUrl']);

      return VendorIdModel.fromJson(nestedData);
    } else {
      throw Exception('Failed to load logo data');
    }
  }

}
