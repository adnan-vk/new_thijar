import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/model/company_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class CompanyController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxList<CompanyModel> companyData = <CompanyModel>[].obs;
  var isLoading = false.obs;

  void getCompanies() async {
    try {
      isLoading.value = true;

      var endpoint = 'company';
      var authToken = await SharedPreLocalStorage.getToken();
      var response = await apiServices.getRequest(
        endurl: endpoint,
        authToken: authToken,
      );

      log("Response: ${response?.data}");

      if (response == null || response.data == null) {
        throw Exception("Response is null");
      }

      List jsonData = response.data['data'] ?? [];
      List<CompanyModel> list =
          jsonData.map((x) => CompanyModel.fromJson(x)).toList();

      companyData.assignAll(list);
    } catch (e) {
      log("Error in getCompanies: $e");
      Get.snackbar("Error", "Failed to fetch companies: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
