import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/Screens/Home/SiginScreen/signinScreen.dart';
import 'package:one_click_builder/themes/Nexus/utility/app_constant.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPassCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();
  final TextEditingController otpCtrl = TextEditingController();
  bool _hideNewPass = true;
  bool _hideConfirmPass = true;

  bool isLoading = false;

  Future<void> resetPassword() async {
    final newPass = newPassCtrl.text.trim();
    final confirmPass = confirmPassCtrl.text.trim();
    final otp = otpCtrl.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('${NexusAppConstant.baseUrl}/api/user/reset-password');

    try {
      final response = await http.put(
        url,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'FlutterApp',
        },
        body: jsonEncode({
          'email': widget.email,
          'password': newPass,
          'confirmPassword': confirmPass,
          'otp': otp,
        }),
      );

      Map<String, dynamic> result;
      try {
        result = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server returned invalid response')),
        );
        return;
      }

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => NexusSignInScreen()),
          (route) => false,
        );
      } else {
        final errorMessage = result['error']?['message'] ?? 'Reset failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Enter Your New Password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Email (Disabled)
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(widget.email),
            ),

            const SizedBox(height: 20),

           TextField(
  controller: newPassCtrl,
  obscureText: _hideNewPass,
  decoration: InputDecoration(
    hintText: "Enter New Password *",
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: Icon(
        _hideNewPass ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _hideNewPass = !_hideNewPass;
        });
      },
    ),
  ),
),


            const SizedBox(height: 20),

         TextField(
  controller: confirmPassCtrl,
  obscureText: _hideConfirmPass,
  decoration: InputDecoration(
    hintText: "Confirm Password *",
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: Icon(
        _hideConfirmPass ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: () {
        setState(() {
          _hideConfirmPass = !_hideConfirmPass;
        });
      },
    ),
  ),
),


            const SizedBox(height: 20),

            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter OTP *",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor:       Color(0xFFF28BA8),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "RESET PASSWORD",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
