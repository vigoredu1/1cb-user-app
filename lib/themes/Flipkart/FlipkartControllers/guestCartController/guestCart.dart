import 'package:get/get.dart';
import 'package:one_click_builder/themes/Flipkart/api/cart/guestCart.dart';
class GuestCartController extends GetxController {
  RxInt guestCartCount = 0.obs;

  Future<void> loadGuestCart() async {
    final data = await GuestCartService.fetchGuestCart();
    if (data != null) {
      guestCartCount.value = data["items"]?.length ?? 0;
    }
  }

  void increaseGuestCart() {
    guestCartCount.value++;
  }
}

