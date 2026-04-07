import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/view/screen/dashboard_screens/dashboard.dart';


import '../../../Vector/utility/images.dart';
import '../../utility/local_storage.dart';
import 'authentication/login/login_page.dart';


class VectorSplashScreen extends StatefulWidget {
  const VectorSplashScreen({super.key});

  @override
  _VectorSplashScreenState createState() => _VectorSplashScreenState();
}

class _VectorSplashScreenState extends State<VectorSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );

        String? token = await StorageHelper.getToken();

        if (token != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }

      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black87,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Images.logo,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Icon(
                Icons.touch_app,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                '1Click',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
