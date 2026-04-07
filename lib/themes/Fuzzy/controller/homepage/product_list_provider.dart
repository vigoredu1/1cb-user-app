import 'package:flutter/material.dart';

import '../../data/model/product_list_model.dart';
import '../../service/home/product_list_api.dart';

class ProductListController with ChangeNotifier {
  List<ProductList> _products = [];
  List<ProductList> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductList> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  final TextEditingController searchController = TextEditingController();

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      _products = await ProductListApiService.fetchProducts();
      _filteredProducts = _products;
    } catch (e) {
      debugPrint('Product loading error ExploreCollectionWidget: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void searchProduct(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
      product.title.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    notifyListeners();
  }

  void clearProducts() {
    _products.clear();
    _filteredProducts.clear();
    notifyListeners();
  }
}
