
import 'package:one_click_builder/themes/Fuzzy/data/model/sub_categery_model.dart';

class SubCategoryResponse {
  final List<SubCategory> data;

  SubCategoryResponse({required this.data});

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<SubCategory> subCategories =
        dataList.map((e) => SubCategory.fromJson(e)).toList();
    return SubCategoryResponse(data: subCategories);
  }
}
