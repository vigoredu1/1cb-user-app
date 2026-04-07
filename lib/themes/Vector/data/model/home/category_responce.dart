import 'category_model.dart';

class CategoryResponse {
  final List<Category> data;

  CategoryResponse({required this.data});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<Category> categories =
        dataList.map((e) => Category.fromJson(e)).toList();
    return CategoryResponse(data: categories);
  }
}
