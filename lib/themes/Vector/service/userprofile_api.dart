import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/model/userprofile_model.dart';
import '../utility/app_constant.dart';
import '../utility/local_storage.dart';

class UserApiService {
  Future<UserResponse> fetchUserData() async {
    String? token = await StorageHelper.getToken();
    final url =
        Uri.parse("${AppConstant.baseUrl}${AppConstant.userprpfile_Url}");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "$token",
      // Add Authorization header if required.
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // print("User_profile");
      // print("Userdata: $data");
      return UserResponse.fromJson(data['data']);
    } else {
      throw Exception("Failed to load user data");
    }
  }
}
