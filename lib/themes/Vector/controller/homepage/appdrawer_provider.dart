import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  // Holds the currently selected drawer item index and title.
  int selectedIndex = 0;
  String selectedItem = "Home";
  bool isCategoriesExpanded = false;

  // Call this function on drawer item tap to update state.
  void updateSelectedItem(int index, String item) {
    selectedIndex = index;
    selectedItem = item;
    notifyListeners();
  }

  void updateCategoriesExpansion(bool expanded) {
    isCategoriesExpanded = expanded;
    notifyListeners();
  }
}
