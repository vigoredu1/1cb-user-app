import 'package:flutter/material.dart';
import '../../../../controller/authentication/login_provider.dart';
import '../../../../controller/dashboard/dashboard_provider.dart';
import '../../../../core_widget/text_field_common.dart';
import '../../../../utility/app_theme.dart';
import '../../../../utility/images.dart';
import '../../../../utility/plugin_list.dart';
import '../../../../utility/svg_assets.dart';
import '../../dashboard_screens/dashboard.dart';
import '../registration/registration.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [

                  Image.asset(
                    Images.background,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  // Foreground UI
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      key: loginProvider.loginKey,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white70,
                                ),
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            controller: loginProvider.emailController,
                            hintText: "Enter your email id",
                            prefixIcon: SvgPicture.asset(
                              SvgAssets.iconEmail,
                              fit: BoxFit.scaleDown,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your email'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: loginProvider.passwordController,
                            hintText: "Enter your password",
                            prefixIcon: SvgPicture.asset(
                              SvgAssets.iconLock,
                              fit: BoxFit.scaleDown,
                            ),
                            obscureText: loginProvider.isNewPassword,
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset(
                                loginProvider.isNewPassword
                                    ? SvgAssets.iconHide
                                    : SvgAssets.iconEye,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white54, // your desired color
                                  BlendMode.srcIn,
                                ),
                              ),
                              onPressed: loginProvider.newPasswordSeenTap,
                            ),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your password'
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: loginProvider.checkedValue,
                                    onChanged: (val) {
                                      loginProvider.checkedValue = val ?? false;
                                      loginProvider.notifyListeners();
                                    },
                                    activeColor: Colors.amber,
                                  ),
                                  Text(
                                    "Remember me",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Forgot password
                                },
                                child: Text(
                                  "Forget password?",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.redAccent),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => loginProvider.onLogin(context),
                              child: Text(
                                "Sign In",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Image.asset(Images.or),
                          const SizedBox(height: 5),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                            create: (_) => DashboardProvider()),
                                      ],
                                      child:
                                      const DashboardScreen(), // Yahan HomeScreen ya Dashboard widget pass karein.
                                    ),
                                  ),
                                      (Route<dynamic> route) =>
                                  false, // Sabhi previous routes ko remove kare.
                                );
                              },
                              child: Text(
                                "Continue as Guest",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                children: [
                                  TextSpan(
                                    text: "Don't have an account?",
                                    style: TextStyle(
                                      color: AppTheme.fromType(
                                              AppTheme.defaultTheme)
                                          .txtTransparentColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Sign up",
                                    style: TextStyle(
                                      color: AppTheme.fromType(
                                              AppTheme.defaultTheme)
                                          .whiteColor,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegistrationScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
