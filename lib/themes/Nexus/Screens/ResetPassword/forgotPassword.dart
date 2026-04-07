import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_click_builder/themes/Nexus/Screens/ResetPassword/resestPassword.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> sendForgotPassword() async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email field cannot be empty")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('https://api.1clickbuilder.com/api/user/forget-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final result = jsonDecode(response.body);
      if (!mounted) return;

      if (result['data'] != null) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Sent Successfully')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']['message'] ?? 'Unknown error'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
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
      appBar: AppBar(title: const Text("Reset Your Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "We will send you an email to reset your password",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Enter your email address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : sendForgotPassword,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("SUBMIT"),
            ),
          ],
        ),
      ),
    );
  }
}
