import 'product_detail_model.dart';

class ProductDetailResponse {
  final ProductDetail product;

  ProductDetailResponse({required this.product});

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      product: ProductDetail.fromJson(json['data']['product']),
    );
  }
}
