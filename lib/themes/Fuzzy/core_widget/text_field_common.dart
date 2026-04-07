import 'package:flutter/material.dart';

import '../utility/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
          color: AppTheme.fromType(AppTheme.defaultTheme).txtTransparentColor,
          fontSize: 14,
          fontWeight: FontWeight.w500),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        filled: true,
        isDense: true,
        hoverColor: AppTheme.fromType(AppTheme.defaultTheme).txtColor,
        fillColor: AppTheme.fromType(AppTheme.defaultTheme).txtColor,
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.amber,
                  width: 3,
                ),
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4), topLeft: Radius.circular(4))),
          child: prefixIcon,
        ),
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color:
                  AppTheme.fromType(AppTheme.defaultTheme).txtTransparentColor,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
