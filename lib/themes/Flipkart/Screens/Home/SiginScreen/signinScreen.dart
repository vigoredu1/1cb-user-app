import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_click_builder/GlobalSplash/global_splash.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/plugin/plugin.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/RegisterAccount/regiisterAccount.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/ResetPassword/forgotPassword.dart';
import 'package:one_click_builder/themes/Flipkart/api/Sigin/sigin.dart';
import 'package:one_click_builder/themes/Flipkart/utility/plugin_list.dart';

class FlipkartSignInScreen extends StatefulWidget {
  const FlipkartSignInScreen({super.key});

  @override
  State<FlipkartSignInScreen> createState() => _FlipkartSignInScreenState();
}

class _FlipkartSignInScreenState extends State<FlipkartSignInScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final FlipkartAuthService authService = FlipkartAuthService();
  bool showPassword = false;
  bool isEmailLogin = true;
  bool isLoading = false;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  String selectedCode = "+91";

  PluginController? get pluginCtrl => Get.isRegistered<PluginController>()
      ? Get.find<PluginController>()
      : null;

  Future<bool> sendOtp(String mobile) async {
    try {
      final vendorCtrl = Get.find<FlipkartVendorController>();

      final response = await http.post(
        Uri.parse("https://api.1clickbuilder.com/api/user/login-with-otp"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(
            {"mobile": "91$mobile", "vendorId": vendorCtrl.vendorId.value}),
      );
      print("mobile: ${"91$mobile"}");
      print("vendorId: ${vendorCtrl.vendorId.value}");

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["data"]["isSuccess"] == true) {
        return true;
      } else {
        errorSnack(data["data"]["message"] ?? "OTP failed");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.1clickbuilder.com/api/user/verify-otp"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"mobile": "91$mobile", "otp": otp}),
      );

      print("VERIFY RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['error'] == null && decoded['data'] != null) {
          final data = decoded['data'];
          final user = data['user'];

          final prefs = await SharedPreferences.getInstance();

          /// SAVE USER DATA
          await prefs.setString('token', data['token']);
          await prefs.setString('email', user['email'] ?? '');
          await prefs.setString('name', user['firstName'] ?? '');
          await prefs.setString('mobile', user['mobile'] ?? '');
          await prefs.setString(
              'profile_picture', user['profilePicture'] ?? '');
          await prefs.setString('role', user['role'] ?? '');

          print("💾 OTP Login success — user saved");

          return true;
        }
      }
    } catch (e) {
      print("OTP VERIFY ERROR: $e");
    }

    return false;
  }

  void showOtpLoginPopup() {
    TextEditingController mobileCtrl = TextEditingController();
    TextEditingController otpCtrl = TextEditingController();

    bool otpSent = false;
    bool isSendingOtp = false;
    bool isVerifyingOtp = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// TOP ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Login with OTP",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// MOBILE INPUT
                    TextField(
                      controller: mobileCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter mobile number",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// OTP FIELD
                    if (otpSent)
                      TextField(
                        controller: otpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter OTP",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: (isSendingOtp || isVerifyingOtp)
                            ? null
                            : () async {
                                String mobile = mobileCtrl.text.trim();

                                /// SEND OTP
                                if (!otpSent) {
                                  if (mobile.length < 10) {
                                    errorSnack("Enter valid mobile number");
                                    return;
                                  }

                                  setState(() {
                                    isSendingOtp = true;
                                  });

                                  bool sent = await sendOtp(mobile);

                                  setState(() {
                                    isSendingOtp = false;
                                  });

                                  if (sent) {
                                    setState(() {
                                      otpSent = true;
                                    });

                                    Get.snackbar(
                                      "OTP Sent",
                                      "Please check your phone",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  }
                                }

                                /// VERIFY OTP
                                else {
                                  String otp = otpCtrl.text.trim();

                                  if (otp.isEmpty) {
                                    errorSnack("Enter OTP");
                                    return;
                                  }

                                  setState(() {
                                    isVerifyingOtp = true;
                                  });

                                  bool verified = await verifyOtp(mobile, otp);

                                  setState(() {
                                    isVerifyingOtp = false;
                                  });

                                  if (verified) {
                                    Get.back();
                                    Get.offAll(() => GlobalSplash());
                                  } else {
                                    errorSnack("Invalid OTP");
                                  }
                                }
                              },
                        child: (isSendingOtp || isVerifyingOtp)
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                otpSent ? "VERIFY OTP" : "SEND OTP",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> handleLogin() async {
    String password = passwordCtrl.text.trim();

    if (password.isEmpty) {
      errorSnack("Password is required");
      return;
    }

    String input = "";

    if (isEmailLogin) {
      input = emailCtrl.text.trim();
      if (input.isEmpty || !GetUtils.isEmail(input)) {
        errorSnack("Please enter a valid email");
        return;
      }
    } else {
      input = phoneCtrl.text.trim();

      if (input.isEmpty || input.length < 10) {
        errorSnack("Please enter a valid phone number");
        return;
      }

      input = "$selectedCode$input"; // correct
    }

    setState(() => isLoading = true);

    final vendorId = Get.isRegistered<FlipkartVendorController>()
        ? Get.find<FlipkartVendorController>().vendorId.value
        : null;
    final errorMessage = await authService.login(
      input: input,
      password: password,
      vendorId: vendorId,
    );

    setState(() => isLoading = false);

    if (errorMessage == null) {
      Get.snackbar(
        'Login Successful',
        'Welcome back!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      Get.offAll(() => GlobalSplash());
    } else {
      errorSnack(errorMessage);
    }
  }

  void errorSnack(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),

              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),

              const SizedBox(height: 20),

              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Sign in with your email or phone',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              const SizedBox(height: 20),

              // ---------------- Toggle Buttons ----------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Email Login"),
                      selected: isEmailLogin,
                      onSelected: (_) {
                        setState(() => isEmailLogin = true);
                      },
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text("Phone Login"),
                      selected: !isEmailLogin,
                      onSelected: (_) {
                        setState(() => isEmailLogin = false);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // ---------------- Email Field ----------------
                    if (isEmailLogin)
                      TextField(
                        controller: emailCtrl,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                    // ---------------- Phone Field with Country Code ----------------
                    if (!isEmailLogin)
                      IntlPhoneField(
                        controller: phoneCtrl,
                        initialCountryCode: "IN",
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (phone) {
                          selectedCode = phone.countryCode;

                          print(phone.countryCode);
                          phoneCtrl.text = phone.number;
                        },
                      ),

                    const SizedBox(height: 16),

                    // ---------------- Password Field ----------------
                    TextField(
                      controller: passwordCtrl,
                      enabled: !isLoading,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => showPassword = !showPassword);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (v) {}),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Reset Password Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),

                    // ---------------- Login Button ----------------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[100],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: isLoading ? null : handleLogin,
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.purple,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.purple),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 10),

                    Obx(() {
                      final controller = pluginCtrl;
                      if (controller != null &&
                          controller.twofactor.value == 1) {
                        return TextButton(
                          onPressed: showOtpLoginPopup,
                          child: const Text("Login with OTP"),
                        );
                      }
                      return const SizedBox();
                    }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "New user? ",
                          style: TextStyle(color: Colors.blue),
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => CreateAccountScreen()),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
