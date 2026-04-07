// import 'package:flutter/material.dart';
//
// import '../model/sub_categery_model.dart';
// import '../model/sub_categery_responce.dart';
// import '../service/sub_categery_service.dart';
//
// class SubCategoryProvider with ChangeNotifier {
//   final SubCategoryApiService _apiService = SubCategoryApiService();
//   List<SubCategory> _subCategories = [];
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   List<SubCategory> get subCategories => _subCategories;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//
//   // This function fetches and filters subcategories based on selected category id.
//   Future<void> loadSubCategories(String categoryId) async {
//     // Clear previous subcategories before loading new ones.
//     _subCategories = [];
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       SubCategoryResponse response = await _apiService.fetchSubCategories();
//       _subCategories = response.data.where((subCat) {
//         // If you need to filter by vendor id as well, uncomment the next line:
//         // return subCat.vendorId == loginVendorId && subCat.category == categoryId;
//         return subCat.category == categoryId;
//       }).toList();
//     } catch (e) {
//       _errorMessage = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }


import 'package:flutter/material.dart';

import '../data/model/sub_categery_model.dart';
import '../data/model/sub_categery_responce.dart';
import '../service/sub_categery_service.dart';

class SubCategoryProvider with ChangeNotifier {
  final SubCategoryApiService _apiService = SubCategoryApiService();
  List<SubCategory> _allSubCategories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SubCategory> get allSubCategories => _allSubCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // This method loads all subcategories from the API just once.
  Future<void> loadAllSubCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      SubCategoryResponse response = await _apiService.fetchSubCategories();
      _allSubCategories = response.data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // This method filters the stored subcategories based on a given category id.
  List<SubCategory> getSubCategoriesByCategory(String categoryId) {
    return _allSubCategories
        .where((subCat) => subCat.category == categoryId)
        .toList();
  }
}
