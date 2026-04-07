import 'package:flutter/material.dart';

class NexusSplashScreen extends StatefulWidget {
  const NexusSplashScreen({super.key});

  @override
  State<NexusSplashScreen> createState() => _NexusSplashScreenState();
}

class _NexusSplashScreenState extends State<NexusSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold
    (
      body: Center(child:Text(".  Nexus Splash Screen data")),
    );
  }
}