import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color? backgroundColor;
  final Size? minimumSize;

  const CommonButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.backgroundColor,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize ?? const Size(300, 50),
        backgroundColor: backgroundColor ?? Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
