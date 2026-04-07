import 'package:one_click_builder/themes/global/api%20&%20model/theme_api.dart';

import '../../Fuzzy/utility/local_storage.dart';
import 'theme_notifier.dart';

class ThemeManager {
  static String selectedTheme = 'fuzzy';

  static Future<void> loadThemeFromApi() async {
    final result = await ThemeService.getThemeData(
      'nexus-preview.1clickbuilder.com',
    );

    if (result != null && result.data.currentTheme.isNotEmpty) {
      selectedTheme = result.data.currentTheme;
    }

    await StorageHelper.saveSelectedTheme(selectedTheme);
    ThemeNotifier.update(selectedTheme);
  }

  static Future<void> loadTheme() async {
    selectedTheme = await StorageHelper.getSelectedTheme() ?? 'fuzzy';
    ThemeNotifier.update(selectedTheme);
  }
}
