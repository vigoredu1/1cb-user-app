import 'package:flutter/material.dart';

class AmzSplashScreen extends StatefulWidget {
  const AmzSplashScreen({super.key});

  @override
  State<AmzSplashScreen> createState() => _AmzSplashScreenState();
}

class _AmzSplashScreenState extends State<AmzSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold
    (
      body: Center(child:Text(".  Amz Splash Screen data")),
    );
  }
}