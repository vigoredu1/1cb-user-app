import 'package:one_click_builder/themes/Vector/data/model/home/product_model.dart';

class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    // Har item ke andar "product" key hai, jismein product details hain.
    List<Product> products =
        dataList.map((e) => Product.fromJson(e['product'])).toList();
    return ProductResponse(products: products);
  }
}
