import 'package:get/get.dart';
import 'package:newthijar/view/menu/sub_screens/cash_in_hand/sub_screens/bank_transfer.dart';

class LoadingController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    // Simulate a loading delay
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to BankTransfer page after the delay
      Get.off(() =>
          const BankTransfer()); // Replace the current screen with BankTransfer
    });
  }
}
