

import 'package:flutter/cupertino.dart';

import '../data/model/home/best_selling_product_model.dart';
import '../data/model/home/product_responce.dart';
import '../service/home/product_api.dart';


class SubCategoryProjectProvider with ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();
  List<Product> _allProducts = [];

  // List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // API ko sirf ek baar call karne ke liye, jab home page load ho.
  Future<void> loadAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {

      // Yahan hum assume kar rahe hain ki agar category_id query parameter nahi diya jaye to API sabhi products return karta hai.
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


  // // Cached products me se selected category ke products filter karen.
  // List<Product> getProductsBySubcategory(String subCategoryId) {
  //   return _allProducts
  //       .where((product) => product.subcategoryId == subCategoryId)
  //       .toList();
  // }
}
