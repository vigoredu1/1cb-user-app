import 'package:flutter/material.dart';

import '../data/model/userprofile_model.dart';
import '../service/userprofile_api.dart';

class UserProvider with ChangeNotifier {
  final UserApiService _apiService = UserApiService();

  UserResponse? _userResponse;
  bool _isLoading = false;
  String? _errorMessage;

  UserResponse? get userResponse => _userResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userResponse = await _apiService.fetchUserData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
