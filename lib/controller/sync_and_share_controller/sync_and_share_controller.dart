// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vyapar_clone/model/add_company_model.dart';
// import 'package:vyapar_clone/model/syn_and__share_model.dart';
// import 'package:vyapar_clone/presentation/menu_screen/sub_screens/manage_companies/controller/my_companies_controller.dart';
// import 'package:vyapar_clone/presentation/menu_screen/sub_screens/sync_and_shear_screen/service/service.dart';
// import 'package:vyapar_clone/repository/app_data/user_data/shared_preferences.dart';

// class SyncAndShareController extends GetxController {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   String userRoleController = "";

//   final SyncAndShareService _service = SyncAndShareService();
//   // final CompanyController companyController = Get.put(CompanyController());
//   // Map to track sync status for each company
//   final RxMap<String, bool> syncStatus = <String, bool>{}.obs;

//   /// Submit company details
//   void addSyncCompany() async {
//     final company = SyncAndShareModel(
//       phoneNo: phoneNumberController.text.trim(),
//       userName: nameController.text.trim(),
//       userRole: userRoleController,
//     );

//     if (company.userName!.isEmpty ||
//         company.phoneNo!.isEmpty ||
//         company.userRole!.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "All fields are required",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     final isSuccess = await _service.addSyncCompany(
//       company.toJson(),
//       await SharedPreLocalStorage.getToken(),
//     );

//     if (isSuccess) {
//       Get.back();
//       Get.snackbar(
//         "Success",
//         "Company added successfully!",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       clearFields();
//     } else {
//       Get.snackbar(
//         "Error",
//         "Failed to add company. Try again.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   /// Clear form fields
//   void clearFields() {
//     nameController.clear();
//     phoneNumberController.clear();
//     userRoleController = "";
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/sync_and_share_model.dart';
import 'package:newthijar/service/sync_and_share_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class SyncAndShareController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController prefixController = TextEditingController();
  String userRoleController = "";

  final SyncAndShareService _service = SyncAndShareService();

  void addSyncCompany() async {
    final company = SyncAndShareModel(
      phoneNo: phoneNumberController.text.trim(),
      userName: nameController.text.trim(),
      userRole: userRoleController,
      prefix: prefixController.text.trim(),
    );

    if (company.userName!.isEmpty ||
        company.phoneNo!.isEmpty ||
        company.userRole!.isEmpty ||
        company.prefix!.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String? token = await SharedPreLocalStorage.getToken();

    if (token == null) {
      Get.snackbar(
        "Error",
        "Authorization token missing",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final isSuccess = await _service.addSyncCompany(company.toJson(), token);

    if (isSuccess) {
      Get.back();
      Get.snackbar(
        "Success",
        "Company added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
    } else {
      Get.snackbar(
        "Error",
        "Failed to add company. Ensure all fields are valid.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void clearFields() {
    nameController.clear();
    phoneNumberController.clear();
    userRoleController = "";
  }
}
