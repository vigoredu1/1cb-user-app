import 'package:flutter/material.dart';

class LogoDisplay extends StatefulWidget {
  const LogoDisplay({super.key});

  @override
  State<LogoDisplay> createState() => _LogoDisplayState();
}

class _LogoDisplayState extends State<LogoDisplay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Image.asset(
        'assets/brand_logo.jpg',
        fit: BoxFit.contain,
      ),
    );
  }
}
