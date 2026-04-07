import 'package:flutter/material.dart';

import '../../data/model/home/best_selling_product_model.dart';
import '../../data/model/home/product_responce.dart';
import '../../service/home/product_api.dart';


class ProductProvider with ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();
  List<Product> _allProducts = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      ProductResponse response =
          await _apiService.fetchProductsWithoutCategory();
      _allProducts = response.products;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cached products me se selected category ke products filter karen.
  List<Product> getProductsByCategory(String categoryId) {
    return _allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }
}
