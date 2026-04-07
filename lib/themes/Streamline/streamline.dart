import 'package:flutter/material.dart';
import 'package:one_click_builder/GlobalSplash/Model/model.dart';

class Streamline extends StatefulWidget {
   final LogoModel logoData;
  const Streamline({super.key,required this.logoData});

  @override
  State<Streamline> createState() => _StreamlineState();
}

class _StreamlineState extends State<Streamline> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "stramloine dararaaaata"
        ),
      ),
    );
  }
}