import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Flipkart/api/register/register.dart';

class CreateAccountScreen extends StatelessWidget {
  final RegisterController regCtrl = Get.put(RegisterController());
  final FlipkartVendorController vendorCtrl = Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final RxBool showPass = false.obs;
  final RxBool showConfirmPass = false.obs;

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  "Join our community and start your journey",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // FIRST & LAST NAME
              Row(
                children: [
                  Expanded(child: inputField("First Name *", firstName)),
                  const SizedBox(width: 16),
                  Expanded(child: inputField("Last Name *", lastName)),
                ],
              ),

              const SizedBox(height: 20),

              inputField("Email (Optional)", email),

              const SizedBox(height: 20),

              // MOBILE FIELD
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Image.network("https://flagcdn.com/w20/in.png", width: 20),
                    const SizedBox(width: 10),
                    const Text("+91", style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
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
                          hintText: "Enter Mobile Number",
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD FIELD
              passwordField(
                "Password *",
                password,
                showPass,
                () => showPass.value = !showPass.value,
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD FIELD
              passwordField(
                "Confirm Password *",
                confirmPassword,
                showConfirmPass,
                () => showConfirmPass.value = !showConfirmPass.value,
              ),

              const SizedBox(height: 20),

              // LOGIN OPTION
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style: TextStyle(color: Colors.black87)),
                  TextButton(
                    onPressed: () => Get.to(() => FlipkartSignInScreen()),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF9A4D7E),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // REGISTER BUTTON
              Obx(() => regCtrl.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: validateAndRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9A4D7E),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
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
