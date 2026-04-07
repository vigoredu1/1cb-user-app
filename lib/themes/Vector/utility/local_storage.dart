import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Remove token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('Token removed');

    // Check immediately
    final after = prefs.getString('auth_token');
    print('Token after removal: $after');
  }


  // Save vendor id
  static Future<void> saveVendorId(String vendorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vendor_id', vendorId);
    print('vendor id' );
    print(vendorId);

  }

  // Get vendor id
  static Future<String?> getVendorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('vendor_id');
  }

  // Remove vendor id
  static Future<void> removeVendorId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('vendor_id');
// <<<<<<< HEAD
    // print('vendor id' );
    // print(prefs);
// =======
    print('vendor id' );
    print(prefs);
// >>>>>>> origin/shubham

  }
  static Future<void> saveLogoUrl(String logoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logo_url', logoUrl);
// <<<<<<< HEAD
    // print('logoUrl');
    // print(prefs);
    // print(logoUrl);
// =======
//     print('logoUrl');
//     print(prefs);
//     print(logoUrl);


  }
    static Future<String?> getLogoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logo_url');
  }
}

Future<void> fetchUserData() async {
  String? token = await StorageHelper.getToken();
  String? vendorId = await StorageHelper.getVendorId();

  print("Tokken checker");
  if (token != null) {
    print("User Token: $token");
  } else {
    print("No token found!");
  }
  if (vendorId != null) {
    print("Vendor ID: $vendorId");
  } else {
    print("No vendor ID found!");
  }
}
