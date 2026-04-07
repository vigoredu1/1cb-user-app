// GENERATED CODE - DO NOT MODIFY BY HAND.
// Run `dart run tool/generate_theme_modules.dart` to regenerate.

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:one_click_builder/GlobalSplash/Model/model.dart';
import 'package:one_click_builder/themes/core/theme_module.dart';
import 'package:one_click_builder/themes/Amazon/Main/main.dart'
    as amazon_main_lib;
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart'
    as amazon_vendor_lib;
import 'package:one_click_builder/themes/Flipkart/Main/main.dart'
    as flipkart_main_lib;
import 'package:one_click_builder/themes/Flipkart/FlipkartVendorId/vendorid.dart'
    as flipkart_vendor_lib;
import 'package:one_click_builder/themes/Nexus/Main/main.dart'
    as nexus_main_lib;
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart'
    as nexus_vendor_lib;

class AmazonGeneratedThemeModule extends ThemeModule {
  const AmazonGeneratedThemeModule();

  @override
  Set<String> get serverKeys => {'amazon', 'amazone', 'amz'};

  @override
  Widget build() => amazon_main_lib.AmzMain();

  @override
  void cacheVendorData(LogoModel logoModel) {
    Get.put(amazon_vendor_lib.AmzVendorController(), permanent: true)
        .setVendorData(
      vendor: logoModel.vendorId ?? '',
      logo: logoModel.logoUrl ?? '',
      emailValue: logoModel.email,
      mobileValue: logoModel.mobile,
      addressValue: logoModel.address,
      copyRightsValue: logoModel.copyRights,
      theme: logoModel.currentTheme,
    );
  }
}

class FlipkartGeneratedThemeModule extends ThemeModule {
  const FlipkartGeneratedThemeModule();

  @override
  Set<String> get serverKeys => {'flipkart'};

  @override
  Widget build() => flipkart_main_lib.FlipkartMain();

  @override
  void cacheVendorData(LogoModel logoModel) {
    Get.put(flipkart_vendor_lib.FlipkartVendorController(), permanent: true)
        .setVendorData(
      vendor: logoModel.vendorId ?? '',
      logo: logoModel.logoUrl ?? '',
      emailValue: logoModel.email,
      mobileValue: logoModel.mobile,
      addressValue: logoModel.address,
      copyRightsValue: logoModel.copyRights,
      theme: logoModel.currentTheme,
    );
  }
}

class NexusGeneratedThemeModule extends ThemeModule {
  const NexusGeneratedThemeModule();

  @override
  Set<String> get serverKeys => {'nexus'};

  @override
  Widget build() => nexus_main_lib.NexusMain();

  @override
  void cacheVendorData(LogoModel logoModel) {
    Get.put(nexus_vendor_lib.NexusVendorController(), permanent: true)
        .setVendorData(
      vendor: logoModel.vendorId ?? '',
      logo: logoModel.logoUrl ?? '',
      emailValue: logoModel.email,
      mobileValue: logoModel.mobile,
      addressValue: logoModel.address,
      copyRightsValue: logoModel.copyRights,
      theme: logoModel.currentTheme,
    );
  }
}

const List<ThemeModule> registeredThemeModules = [
  AmazonGeneratedThemeModule(),
  FlipkartGeneratedThemeModule(),
  NexusGeneratedThemeModule(),
];
