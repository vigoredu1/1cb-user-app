import 'package:flutter/widgets.dart';
import 'package:one_click_builder/GlobalSplash/Model/model.dart';

abstract class ThemeModule {
  const ThemeModule();

  Set<String> get serverKeys;

  Widget build();

  void cacheVendorData(LogoModel logoModel);
}
