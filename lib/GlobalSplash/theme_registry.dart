import 'package:flutter/widgets.dart';
import 'package:one_click_builder/GlobalSplash/Model/model.dart';
import 'package:one_click_builder/themes/Nexus/Main/main.dart';
import 'package:one_click_builder/themes/generated/theme_modules.g.dart';

class ThemeRegistry {
  static final _registrations = registeredThemeModules;

  static void cacheVendorDataForAllThemes(LogoModel logoModel) {
    for (final registration in _registrations) {
      registration.cacheVendorData(logoModel);
    }
  }

  static Widget resolveTheme(LogoModel logoModel) {
    final candidates = <String?>[
      logoModel.currentMobileTheme,
      logoModel.currentTheme,
    ];

    for (final candidate in candidates) {
      final normalized = _normalizeServerTheme(candidate);
      if (normalized == null) {
        continue;
      }

      for (final registration in _registrations) {
        if (registration.serverKeys.contains(normalized)) {
          return registration.build();
        }
      }
    }

    return NexusMain();
  }

  static String? _normalizeServerTheme(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
