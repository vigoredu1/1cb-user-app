import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/authentication/registration_provider.dart';
import '../../../../../core_widget/common_button.dart';


class RegistrationTextFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const RegistrationTextFields({
    super.key,
    required this.formKey,
  });

  @override
  State<RegistrationTextFields> createState() => _RegistrationTextFieldsState();
}

class _RegistrationTextFieldsState extends State<RegistrationTextFields> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    final registrationProvider = Provider.of<RegistrationProvider>(context);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // First Name Input Field
          TextFormField(
            controller: registrationProvider.firstNameController,
            decoration: InputDecoration(
              labelText: 'Enter First Name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Last Name Input Field
          TextFormField(
            controller: registrationProvider.lastNameController,
            decoration: InputDecoration(
              labelText: 'Enter Last Name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Email Input Field
          TextFormField(
            controller: registrationProvider.emailController,
            decoration: InputDecoration(
              labelText: 'Enter Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Password Input Field with toggle visibility
          TextFormField(
            controller: registrationProvider.passwordController,
            decoration: InputDecoration(
              labelText: 'Enter Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: _obscureText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Confirm Password Input Field with toggle visibility
          TextFormField(
            controller: registrationProvider.confpasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmText = !_obscureConfirmText;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            obscureText: _obscureConfirmText,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != registrationProvider.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),

          CommonButton(
              onTap: () {
                registrationProvider.onRegistration(context);
              },
              buttonText: 'Sign up'),
        ],
      ),
    );
  }
}
