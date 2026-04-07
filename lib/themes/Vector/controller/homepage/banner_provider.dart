import 'package:flutter/material.dart';

import '../../data/model/home/banner_model.dart';
import '../../service/home/banner_api.dart';

class BannerProvider with ChangeNotifier {
  final BannerApiService _apiService = BannerApiService();

  List<BannerItem> _banners = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BannerItem> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBanners() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<BannerItem> fetchedBanners = await _apiService.fetchBanners();
      _banners = fetchedBanners;
    } catch (e) {
      _errorMessage = e.toString();
      _banners = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
