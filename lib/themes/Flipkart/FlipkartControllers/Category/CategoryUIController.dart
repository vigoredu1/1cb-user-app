import 'package:get/get.dart';





class FlipkartCategoryUIController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final RxString selectedSubCategoryId = "".obs;
  final RxString selectedSubCategoryName = "".obs;

  void select(int index) {
    selectedIndex.value = index;
    clearSubCategory();
  }

  void selectSubCategory(String id, String name) {
    selectedSubCategoryId.value = id;
    selectedSubCategoryName.value = name;
  }

  void clearSubCategory() {
    selectedSubCategoryId.value = "";
    selectedSubCategoryName.value = "";
  }
}
