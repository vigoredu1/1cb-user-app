import 'package:flutter/material.dart';

import '../data/model/product_detail_model.dart';
import '../data/model/product_detail_service.dart';
import '../service/product_detail_api.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductDetailApiService _apiService = ProductDetailApiService();
  ProductDetail? productDetail;
  bool isLoading = false;
  String? errorMessage;
  bool _descriptionExpanded = false;
  bool _isLiked = false;

  bool get descriptionExpanded => _descriptionExpanded;
  bool get isLiked => _isLiked;

  Future<void> loadProductDetail(String productId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      ProductDetailResponse response =
          await _apiService.fetchProductDetail(productId);
      productDetail = response.product;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleDescription() {
    _descriptionExpanded = !_descriptionExpanded;
    notifyListeners();
  }

  void toggleLike() {
    _isLiked = !_isLiked;
    notifyListeners();
  }
}
