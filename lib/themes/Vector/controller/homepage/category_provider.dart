// lib/providers/category_provider.dart
import 'package:flutter/material.dart';

import '../../data/model/home/category_model.dart';
import '../../data/model/home/category_responce.dart';
import '../../service/home/category_api.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  String loginVendorId = "88e06cdb-bdde-11ef-ad07-00163c34c678";
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  // final String loginVendorId = "88e06cdb-bdde-11ef-ad07-00163c34c678";

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      CategoryResponse response = await _apiService.fetchCategories();
      // String? loginVendorId = await StorageHelper.getVendorId();
      // Filter: Yahan aap chahte hain ki sirf unhi categories ko dikhaye jaye jinke vendorId match ho.
      _categories = response.data.where((category) {
        return category.vendorId == loginVendorId;
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
