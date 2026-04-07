import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_click_builder/GlobalSplash/global_splash.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Controllers/Plugin/plugin.dart';
import 'package:one_click_builder/themes/Amazon/Screens/RegisterAccount/regiisterAccount.dart';
import 'package:one_click_builder/themes/Amazon/Screens/ResetPassword/forgotPassword.dart';
import 'package:one_click_builder/themes/Amazon/api/Sigin/sigin.dart';
import 'package:one_click_builder/themes/Amazon/utility/plugin_list.dart';

class AmzSignInScreen extends StatefulWidget {
  const AmzSignInScreen({super.key});

  @override
  State<AmzSignInScreen> createState() => _AmzSignInScreenState();
}

class _AmzSignInScreenState extends State<AmzSignInScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final NexusAuthService authService = NexusAuthService();
  bool showPassword = false;
  bool isEmailLogin = true;
  bool isLoading = false;
  PluginController? get pluginCtrl => Get.isRegistered<PluginController>()
      ? Get.find<PluginController>()
      : null;

  String selectedCode = "+91";

  void showOtpLoginPopup() {
    TextEditingController mobileCtrl = TextEditingController();
    TextEditingController otpCtrl = TextEditingController();

    bool otpSent = false;
    bool isSendingOtp = false;
    bool isVerifyingOtp = false;
    Future<bool> sendOtp(String mobile) async {
      try {
        final vendorCtrl = Get.find<AmzVendorController>();

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

    final vendorId = Get.isRegistered<AmzVendorController>()
        ? Get.find<AmzVendorController>().vendorId.value
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(height: 60),

            const SizedBox(height: 30),
            const SizedBox(height: 30),

            /// 🧾 LOGIN CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign in",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔁 EMAIL / PHONE TOGGLE
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("Email"),
                        selected: isEmailLogin,
                        onSelected: (_) => setState(() => isEmailLogin = true),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text("Phone"),
                        selected: !isEmailLogin,
                        onSelected: (_) => setState(() => isEmailLogin = false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 📧 EMAIL
                  if (isEmailLogin)
                    TextField(
                      controller: emailCtrl,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),

                  /// 📱 PHONE
                  if (!isEmailLogin)
                    IntlPhoneField(
                      controller: phoneCtrl,
                      initialCountryCode: "IN",
                      decoration: const InputDecoration(
                        labelText: "Mobile number",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (phone) {
                        selectedCode = phone.countryCode;
                        phoneCtrl.text = phone.number;
                      },
                    ),

                  const SizedBox(height: 12),

                  /// 🔒 PASSWORD
                  TextField(
                    controller: passwordCtrl,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔗 FORGOT
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => ForgotPasswordScreen());
                      },
                      child: const Text("Forgot password?"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      onPressed: isLoading ? null : handleLogin,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "Sign in",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 📜 TERMS
                  const Text(
                    "By continuing, you agree to our Conditions of Use and Privacy Notice.",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Obx(() {
              final controller = pluginCtrl;
              if (controller != null && controller.twofactor.value == 1) {
                return TextButton(
                  onPressed: showOtpLoginPopup,
                  child: const Text("Login with OTP"),
                );
              }
              return const SizedBox();
            }),

            /// ➖ DIVIDER
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("New to Our Platform?"),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),

            const SizedBox(height: 16),

            /// 🆕 CREATE ACCOUNT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  onPressed: () => Get.to(() => CreateAccountScreen()),
                  child: const Text(
                    "Create your account",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:one_click_builder/themes/Nexus/Main/main.dart';
// import 'package:one_click_builder/themes/Nexus/Screens/RegisterAccount/regiisterAccount.dart';
// import 'package:one_click_builder/themes/Nexus/api/Sigin/sigin.dart';

// class NexusSignInScreen extends StatefulWidget {
//   const NexusSignInScreen({super.key});

//   @override
//   State<NexusSignInScreen> createState() => _NexusSignInScreenState();
// }

// class _NexusSignInScreenState extends State<NexusSignInScreen> {
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passwordCtrl = TextEditingController();
//   final NexusAuthService authService = NexusAuthService();
// bool showPassword = false;

//   bool isLoading = false;
// Future<void> handleLogin() async {
//   String input = emailCtrl.text.trim();
//   String password = passwordCtrl.text.trim();

//   if (input.isEmpty || password.isEmpty) {
//     Get.snackbar(
//       'Error',
//       'Email/Phone and password are required',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//     return;
//   }

//   // If input contains only numbers → treat as phone number
//   if (RegExp(r'^[0-9]+$').hasMatch(input)) {
//     if (!input.startsWith('+91')) {
//       input = '+91$input';
//     }
//     print("Login with phone: $input");
//   } else {
//     print("Login with email: $input");
//   }

//   setState(() => isLoading = true);

//   bool success = await authService.login(
//     input,   // email OR +91 phone
//     password,
//   );

//   setState(() => isLoading = false);

//   if (success) {
//     Get.snackbar(
//       'Login Successful',
//       'Welcome back!',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       icon: const Icon(Icons.check_circle, color: Colors.white),
//     );

//     Get.offAll(() => NexusMain());
//   } else {
//     Get.snackbar(
//       'Login Failed',
//       'Invalid credentials',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
// }

//   @override
//   void dispose() {
//     emailCtrl.dispose();
//     passwordCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 100),

//             CircleAvatar(
//               radius: 40,
//               backgroundColor: Colors.blue[100],
//               child: const Icon(Icons.person, size: 50, color: Colors.white),
//             ),

//             const SizedBox(height: 20),

//             const Text(
//               'Welcome Back',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 8),

//             Text(
//               'Sign in with your email or phone number',
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),

//             const SizedBox(height: 30),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 children: [
//                   TextField(
//   controller: emailCtrl,
//   enabled: !isLoading,
//   keyboardType: TextInputType.emailAddress,
//   decoration: InputDecoration(
//     prefixIcon: const Icon(Icons.person),
//     hintText: 'Email or Phone Number',
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     contentPadding: const EdgeInsets.symmetric(vertical: 16),
//   ),
// ),

//                   const SizedBox(height: 16),

//                   TextField(
//   controller: passwordCtrl,
//   enabled: !isLoading,
//   obscureText: !showPassword, // 👈 show/hide logic
//   decoration: InputDecoration(
//     prefixIcon: const Icon(Icons.lock),
//     hintText: 'Enter your password',
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     contentPadding: const EdgeInsets.symmetric(vertical: 16),

//     // 👇 show/hide icon
//     suffixIcon: IconButton(
//       icon: Icon(
//         showPassword ? Icons.visibility : Icons.visibility_off,
//       ),
//       onPressed: () {
//         setState(() {
//           showPassword = !showPassword;
//         });
//       },
//     ),
//   ),
// ),

//                   const SizedBox(height: 16),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.pink[100],
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: isLoading ? null : handleLogin,
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 22,
//                               width: 22,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.purple,
//                               ),
//                             )
//                           : const Text(
//                               'Sign In',
//                               style: TextStyle(color: Colors.purple),
//                             ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),

//             Container(
//               width: double.infinity,
//               color: Colors.purple[300],
//               padding: const EdgeInsets.symmetric(
//                   vertical: 40, horizontal: 24),
//               child: Column(
//                 children: [
//                   const Icon(Icons.person_add,
//                       size: 40, color: Colors.white),

//                   const SizedBox(height: 16),

//                   const Text(
//                     'New to Our Platform?',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   const Text(
//                     'Join our growing community today!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white),
//                   ),

//                   const SizedBox(height: 16),

//                OutlinedButton(
//   style: OutlinedButton.styleFrom(
//     side: const BorderSide(color: Colors.white),
//     padding: const EdgeInsets.symmetric(
//       vertical: 16,
//       horizontal: 40,
//     ),
//   ),
//   onPressed: isLoading
//       ? null
//       : () {
//           Get.to(() => CreateAccountScreen());
//         },
//   child: const Text(
//     'Create Account',
//     style: TextStyle(color: Colors.white),
//   ),
// )

//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
