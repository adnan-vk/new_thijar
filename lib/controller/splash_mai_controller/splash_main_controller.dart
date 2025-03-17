import 'dart:async';
import 'package:get/get.dart';
import 'package:newthijar/model/credential_model.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:newthijar/view/splash_screen/splash_screen.dart';
// import '../../../../core/models/credential_model.dart';
// import '../../../../repository/app_data/user_data/shared_preferences.dart';
// import '../../../bottom_navigation_screen/view/bottom_navigation_screen.dart';
// import '../../view/onboarding_screen.dart';

class SplashMainController extends GetxController {
  void splashEngine() {
    Timer(Duration(seconds: 3.toInt()), () async {
      CredentialModel model = await SharedPreLocalStorage.getCredential();
      printInfo(info: "token ==${model.token}");
      printInfo(info: "userId ==${model.userId}");
      if (model.token == '') {
        Get.off(() => const SplashScreen());
      } else {
        Get.off(() => const BottomNavigationScreen());
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    splashEngine();
  }
}
