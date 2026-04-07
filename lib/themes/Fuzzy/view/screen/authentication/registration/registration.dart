import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:svg_flutter/svg.dart';

import '../../../../controller/authentication/registration_provider.dart';
import '../../../../core_widget/text_field_common.dart'; // मान लिया गया कि यह आपका CustomTextField है
import '../../../../utility/app_theme.dart';
import '../../../../utility/images.dart';
import '../../../../utility/svg_assets.dart';
import '../login/login_page.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // 💡 Note: Local Controllers हटा दिए गए हैं, अब सीधे Provider के Controllers का उपयोग होगा।

  @override
  Widget build(BuildContext context) {
    // 💡 ध्यान दें: Provider को listen: false के साथ उपयोग करना बेहतर है क्योंकि हम यहां setState नहीं कर रहे हैं।
    final registrationProvider = Provider.of<RegistrationProvider>(context, listen: false);
    final theme = AppTheme.fromType(AppTheme.defaultTheme);

    // सुनिश्चित करें कि Form Key Provider को भी पास किया जाए (यदि Provider में Validate लॉजिक है)
    registrationProvider.registrationKey = _formKey;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          // ⚠️ Warning: Stack के अंदर Image.asset का उपयोग करने पर अगर Image का size बड़ा हो,
          // तो वह बटन को ब्लॉक कर सकता है। अगर बटन फिर भी काम न करे तो Stack हटा दें।
          child: Stack(
            children: [
              Image.asset(
                Images.background,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding बढ़ाई गयी
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 160),
                      const Text("Let’s you in",
                          style: TextStyle(
                              fontFamily: 'Optima LT',
                              color: Colors.white,
                              fontSize: 22)),
                      const SizedBox(height: 8),
                      Text(
                        "Hey, You have been missed !",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // =========================================================
                      // 🚀 First Name
                      CustomTextField(
                        controller: registrationProvider.firstNameController,
                        hintText: "Enter First Name",
                        prefixIcon: SvgPicture.asset(
                          SvgAssets.iconProfile,
                          colorFilter: ColorFilter.mode(
                              theme.txtTransparentColor, BlendMode.srcIn),
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your first name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 🚀 Last Name
                      CustomTextField(
                        controller: registrationProvider.lastNameController,
                        hintText: "Enter Last Name",
                        prefixIcon: SvgPicture.asset(
                          SvgAssets.iconProfile,
                          colorFilter: ColorFilter.mode(
                              theme.txtTransparentColor, BlendMode.srcIn),
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your last name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // =========================================================

                      // Email
                      CustomTextField(
                        controller: registrationProvider.emailController,
                        hintText: "Enter your email",
                        prefixIcon: SvgPicture.asset(
                          SvgAssets.iconEmail,
                          fit: BoxFit.scaleDown,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      CustomTextField(
                        controller: registrationProvider.passwordController,
                        hintText: "Enter your password",
                        prefixIcon: SvgPicture.asset(
                          SvgAssets.iconLock,
                          fit: BoxFit.scaleDown,
                        ),
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            _obscurePassword ? SvgAssets.iconHide : SvgAssets.iconEye,
                            colorFilter: const ColorFilter.mode(
                              Colors.white54,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      CustomTextField(
                        controller: registrationProvider.confpasswordController,
                        hintText: "Confirm your password",
                        prefixIcon: SvgPicture.asset(
                          SvgAssets.iconLock,
                          fit: BoxFit.scaleDown,
                        ),
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: SvgPicture.asset(
                            _obscureConfirmPassword ? SvgAssets.iconHide : SvgAssets.iconEye,
                            colorFilter: const ColorFilter.mode(
                              Colors.white54,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value != registrationProvider.passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Sign Up Button (अब यह काम करना चाहिए)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // 🚀 अब Validate करें और फिर Provider की मेथड कॉल करें
                            if (_formKey.currentState!.validate()) {
                              print('✅ Validation Passed. Calling onRegistration.'); // Debugging!
                              registrationProvider.onRegistration(context);
                            } else {
                              print('❌ Validation Failed.'); // Debugging!
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // 💡 ध्यान दें: Images.or एक एसेट है, सुनिश्चित करें कि यह सही से लोड हो।
                      Center(child: Image.asset(Images.or)),
                      const SizedBox(height: 20),

                      // Already have an account? (Login Button)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(color: theme.txtTransparentColor),
                          ),
                          // 🚀 Login/Sign In बटन को TextButton से बदल दिया गया
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()));
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}