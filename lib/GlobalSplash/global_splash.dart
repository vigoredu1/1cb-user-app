import 'package:flutter/material.dart';
import 'package:one_click_builder/GlobalSplash/Model/model.dart';
import 'package:one_click_builder/GlobalSplash/logoapi.dart';
import 'package:one_click_builder/GlobalSplash/theme_registry.dart';

class GlobalSplash extends StatefulWidget {
  const GlobalSplash({
    super.key,
    this.logoLoader = LogoService.getLogoData,
  });

  final Future<LogoModel> Function() logoLoader;

  @override
  State<GlobalSplash> createState() => _GlobalSplashState();
}

class _GlobalSplashState extends State<GlobalSplash> {
  @override
  void initState() {
    super.initState();
    _fetchThemeAndNavigate();
  }

  Future<void> _fetchThemeAndNavigate() async {
    try {
      final logoModel = await widget.logoLoader();
      ThemeRegistry.cacheVendorDataForAllThemes(logoModel);
      _navigateToTheme(ThemeRegistry.resolveTheme(logoModel));
    } catch (e, stack) {
      debugPrint('Global splash failed: $e');
      debugPrint('$stack');
      _showError();
    }
  }

  void _navigateToTheme(Widget destination) {
    if (!mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => destination),
      );
    });
  }

  void _showError() {
    _navigateToTheme(ThemeRegistry.resolveTheme(LogoModel()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/brand_logo.jpg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
