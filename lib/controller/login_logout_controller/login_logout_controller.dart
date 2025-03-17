import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/controller/splash_controller/splash_conroller.dart';
import 'package:newthijar/model/credential_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:newthijar/view/login_page/login_page.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class LoginController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  RxBool isFlat = true.obs;
  @override
  void onInit() {
    super.onInit();
    deleteSplashMemory();
  }

  void deleteSplashMemory() {
    Get.delete<SplashScreenController>(tag: 'Splash memory deleted');
  }

  logout() async {
    setLoadingValue(true);

    try {
      // await SharedPreLocalStorage.clearCredentials();

      var response =
          await _apiServices.postJsonData(data: {}, endUrl: EndUrl.logoutUrl);
      log("response log out== $response");
      if (response != null &&
          CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        await SharedPreLocalStorage.clear();
        Get.offAll(() => LoginPage());

        SnackBars.showSuccessSnackBar(text: "You are logged out.");
      }

      setLoadingValue(false);
    } catch (e) {
      SnackBars.showAlertSnackBar(text: "Failed to log out.");
      setLoadingValue(false);
    }
  }

  void login({required String number, context}) async {
    setLoadingValue(true);

    try {
      var data = {"phoneNo": int.parse(number)};
      var response =
          await _apiServices.postJsonData(data: data, endUrl: EndUrl.loginUrl);

      if (response != null) {
        setLoadingValue(false);

        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          // Ensure response structure
          var userData = response.data?["data"]?["user"];
          if (userData != null) {
            try {
              CredentialModel model = CredentialModel(
                token: response.data["data"]["token"],
                userId: userData["id"],
                phoneNo: userData["details"]?["phoneNo"],
              );
              await SharedPreLocalStorage.setCredential(model);
              Get.offAll(() => const BottomNavigationScreen());
              SnackBars.showSuccessSnackBar(text: "You are logged in.");
            } catch (e, stackTrace) {
              SnackBars.showAlertSnackBar(
                  text: "Failed to save user credential: $e");
              log("Error in login process: $e");
              log("Stack trace: $stackTrace");
            }
          } else {
            SnackBars.showAlertSnackBar(text: "Invalid user data.");
            log("User data is null: ${response.data}");
          }
        }
      } else {
        SnackBars.showAlertSnackBar(text: "Null response from API.");
      }
    } catch (e, stackTrace) {
      SnackBars.showAlertSnackBar(text: "Error occurred: $e");
      log("Error: $e");
      log("Stack trace: $stackTrace");
    } finally {
      setLoadingValue(false);
    }
  }

  void register({number}) async {
    setLoadingValue(true);

    var data = {"phoneNo": int.parse(number)};
    var response =
        await _apiServices.postJsonData(data: data, endUrl: EndUrl.registerUrl);
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        try {
          CredentialModel model = CredentialModel(
              token: response.data["data"]["token"],
              userId: response.data["data"]["user"]["id"],
              phoneNo: response.data["data"]["user"]["details"]["phoneNo"]);
          await SharedPreLocalStorage.setCredential(model);
          Get.off(() => const BottomNavigationScreen());
          SnackBars.showSuccessSnackBar(text: "You are registered.");
        } catch (e) {
          setLoadingValue(false);
          SnackBars.showAlertSnackBar(text: "Failed to save user credential.");
        }

        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }
}
