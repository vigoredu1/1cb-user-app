import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Amazon/api/register/register.dart';

class CreateAccountScreen extends StatelessWidget {
  final RegisterController regCtrl = Get.put(RegisterController());
  final AmzVendorController vendorCtrl = Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final RxBool showPass = false.obs;
  final RxBool showConfirmPass = false.obs;
  final RxBool acceptTerms = false.obs;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🧾 SIGN UP CARD
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
                      "Create account",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 👤 NAME
                    inputField("First name", firstName),
                    const SizedBox(height: 12),
                    inputField("Last name", lastName),

                    const SizedBox(height: 12),

                    /// 📧 EMAIL
                    inputField("Email (optional)", email),

                    const SizedBox(height: 12),

                    /// 📱 MOBILE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mobile number",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                "https://flagcdn.com/w20/in.png",
                                width: 20,
                              ),
                              const SizedBox(width: 6),
                              const Text("+91"),
                              const SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  controller: mobile,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Mobile number",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// 🔒 PASSWORD
                    passwordField(
                      "Password",
                      password,
                      showPass,
                      () => showPass.value = !showPass.value,
                    ),

                    const SizedBox(height: 12),

                    /// 🔒 CONFIRM
                    passwordField(
                      "Re-enter password",
                      confirmPassword,
                      showConfirmPass,
                      () => showConfirmPass.value = !showConfirmPass.value,
                    ),

                    const SizedBox(height: 16),

                    /// 🟡 CREATE ACCOUNT BUTTON
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.black,
                            elevation: 0,
                          ),
                          onPressed: regCtrl.isLoading.value
                              ? null
                              : validateAndRegister,
                          child: regCtrl.isLoading.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "Create your account",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 📜 TERMS
                    Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: acceptTerms.value,
                            onChanged: (v) {
                              acceptTerms.value = v!;
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "By creating an account, you agree to our Terms & Conditions.",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔁 SIGN IN LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Get.off(() => AmzSignInScreen()),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // INPUT FIELD
  Widget inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 16), // FIX TEXT ALIGNMENT
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // PASSWORD FIELD
  Widget passwordField(String label, TextEditingController controller,
      RxBool visibility, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white,
          ),
          child: Obx(() => TextField(
                controller: controller,
                obscureText: !visibility.value,
                decoration: InputDecoration(
                  border: InputBorder.none,

                  // CENTER TEXT VERTICALLY
                  contentPadding: const EdgeInsets.only(top: 16),

                  suffixIcon: IconButton(
                    icon: Icon(
                      visibility.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: toggle,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // VALIDATION
  void validateAndRegister() {
    String f = firstName.text.trim();
    String l = lastName.text.trim();
    String mail = email.text.trim();
    String mob = mobile.text.trim();
    String pass = password.text.trim();
    String cPass = confirmPassword.text.trim();

    if (f.isEmpty) return error("First Name is required");
    if (l.isEmpty) return error("Last Name is required");

    if (mob.length != 10) return error("Mobile number must be 10 digits");

    if (mail.isNotEmpty &&
        !RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(mail)) {
      return error("Enter a valid email address");
    }

    if (pass.length < 6) return error("Password must be 6+ characters");

    if (pass != cPass) return error("Passwords do not match");

    /// ✅ TERMS CHECK
    if (!acceptTerms.value) {
      return error("Please accept Terms & Conditions");
    }

    regCtrl.registerUser(
      first: f,
      last: l,
      email: mail,
      mobile: "91$mob",
      password: pass,
      confirm: cPass,
    );
  }

  void error(String msg) {
    Get.snackbar("Error", msg,
        backgroundColor: Colors.redAccent, colorText: Colors.white);
  }
}
