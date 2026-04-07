import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 290,
      child: Image(
        image: NetworkImage(
            "https://img.freepik.com/premium-vector/illustration-vector-graphic-cartoon-character-login_516790-1261.jpg"),
        fit: BoxFit.cover,
      ),
    );
  }
}
