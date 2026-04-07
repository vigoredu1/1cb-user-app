import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/utility/plugin_list.dart';

class AmzVendorController extends GetxController {
 /// Vendor basics
  final RxString vendorId = ''.obs;
  final RxString logoUrl = ''.obs;

  /// Contact / Store info
  final RxString email = ''.obs;
  final RxString mobile = ''.obs;
  final RxString address = ''.obs;
  final RxString copyRights = ''.obs;

  /// Theme
  final RxString currentTheme = ''.obs;

  /// Loading
  final RxBool loading = true.obs;

  /// 🔥 Save ALL vendor + logo + contact data
  Future<void> setVendorData({
    required String vendor,
    required String logo,
    String? emailValue,
    String? mobileValue,
    String? addressValue,
    String? copyRightsValue,
    String? theme,
  }) async {
    vendorId.value = vendor;
    logoUrl.value = logo;
    email.value = emailValue ?? '';
    mobile.value = mobileValue ?? '';
    address.value = addressValue ?? '';
    copyRights.value = copyRightsValue ?? '';
    currentTheme.value = theme ?? '';

    loading.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vendor_id', vendor);
    await prefs.setString('vendor_logo', logo);
    await prefs.setString('vendor_email', email.value);
    await prefs.setString('vendor_mobile', mobile.value);
    await prefs.setString('vendor_address', address.value);
    await prefs.setString('vendor_copyright', copyRights.value);
    await prefs.setString('vendor_theme', currentTheme.value);

    print("✅ Vendor FULL data saved");
  }

  /// Load vendor on app start
  Future<void> loadVendorFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    vendorId.value = prefs.getString('vendor_id') ?? '';
    logoUrl.value = prefs.getString('vendor_logo') ?? '';
    email.value = prefs.getString('vendor_email') ?? '';
    mobile.value = prefs.getString('vendor_mobile') ?? '';
    address.value = prefs.getString('vendor_address') ?? '';
    copyRights.value = prefs.getString('vendor_copyright') ?? '';
    currentTheme.value = prefs.getString('vendor_theme') ?? '';

    loading.value = false;

    print("📦 Vendor loaded from storage");
  }
}
