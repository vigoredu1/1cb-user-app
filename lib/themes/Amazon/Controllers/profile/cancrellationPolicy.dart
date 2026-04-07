import 'package:get/get.dart';
import 'package:one_click_builder/themes/Amazon/AmzVendorId/vendorid.dart';
import 'package:one_click_builder/themes/Amazon/api/profile/cancellationPolicy.dart';
import 'package:get/get.dart';

import '../../Modules/profile/AmzCancellationPolicy.dart';


class CancellationPolicyController extends GetxController {
  final AmzVendorController vendorController = Get.find();

  var isLoading = true.obs;
  var policy = Rxn<CancellationPolicyData>();

  @override
  void onInit() {
    super.onInit();

    /// Wait until vendorId is ready
    ever(vendorController.vendorId, (String id) {
      if (id.isNotEmpty) {
        loadPolicy(id);
      }
    });
  }

  Future<void> loadPolicy(String vendorId) async {
    try {
      isLoading(true);
      policy.value =
          await CancellationPolicyService.fetchPolicy(vendorId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
