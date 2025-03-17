// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:newthijar/model/prefix_model.dart';
// import 'package:newthijar/service/transaction_service.dart';
// import 'package:newthijar/shared_preference/shared_preference.dart';

// class Transactioncontroller extends ChangeNotifier {
//   TextEditingController prefixController = TextEditingController();
//   final TransactionService _service = TransactionService();

//   void addPrefix() async {
//     final prefix = PrefixModel(prefix: prefixController.text.trim());

//     if (prefix.prefix!.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please enter a Prefix",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     String? token = await SharedPreLocalStorage.getToken();

//     final isSuccess = await _service.addPrefix(prefix.toJson(), token);

//     if (isSuccess) {
//       Get.back();
//       Get.snackbar(
//         "Success",
//         "Prefix Added Scuccessfully !",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );

//       clearFields();
//     } else {
//       Get.snackbar(
//         "Error",
//         "Failed to add Prefix",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }

//   clearFields() {
//     prefixController.clear();
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/transaction_settings_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/transaction_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class Transactioncontroller extends GetxController {
  TextEditingController prefixController = TextEditingController();
  final TransactionService _service = TransactionService();
  ApiServices apiServices = ApiServices();
  RxBool enableDeliveryChallan = false.obs;
  RxBool enableEstimate = false.obs;
  RxBool enableExportSales = false.obs;
  RxBool enableImportPurchase = false.obs;
  RxBool enablePartyEmail = false.obs;
  RxBool enablePurchaseOrder = false.obs;
  RxBool enableSalesOrder = false.obs;
  RxBool enableShippingAddress = false.obs;

  Rx<TransactionSettingModel> settingModel = TransactionSettingModel().obs;
  // void addPrefix() async {
  //   final prefix = PrefixModel(prefix: prefixController.text.trim());

  //   if (prefix.prefix!.isEmpty) {
  //     Get.snackbar(
  //       "Error",
  //       "Please enter a Prefix",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   String? token = await SharedPreLocalStorage.getToken();

  //   final isSuccess = await _service.addPrefix(prefix.toJson(), token);

  //   if (isSuccess) {
  //     Get.back();
  //     Get.snackbar(
  //       "Success",
  //       "Prefix Added Scuccessfully !",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );

  //     clearFields();
  //   } else {
  //     Get.snackbar(
  //       "Error",
  //       "Failed to add Prefix",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  clearFields() {
    prefixController.clear();
  }

  itemSettingsChange() {
    updatedItemSettings(
      enableDeliveryChallan: enableDeliveryChallan.value,
      enableEstimate: enableEstimate.value,
      enableExportSales: enableExportSales.value,
      enableImportPurchase: enableImportPurchase.value,
      enablePartyEmail: enablePartyEmail.value,
      enablePurchaseOrder: enablePurchaseOrder.value,
      enableSalesOrder: enableSalesOrder.value,
      enableShippingAddress: enableShippingAddress.value,
    );
  }

  updatedItemSettings({
    bool? enableDeliveryChallan,
    bool? enableEstimate,
    bool? enableExportSales,
    bool? enableImportPurchase,
    bool? enablePartyEmail,
    bool? enablePurchaseOrder,
    bool? enableSalesOrder,
    bool? enableShippingAddress,
  }) async {
    setLoadingValue(true);
    var data = {
      "enableDeliveryChallan": enableDeliveryChallan,
      "enableEstimate": enableEstimate,
      "enableExportSales": enableExportSales,
      "enableImportPurchase": enableImportPurchase,
      "enablePartyEmail": enablePartyEmail,
      "enablePurchaseOrder": enablePurchaseOrder,
      "enableSalesOrder": enableSalesOrder,
      "enableShippingAddress": enableShippingAddress,
    };

    var response = await apiServices.putJsonData(
      authToken: await SharedPreLocalStorage.getToken(),
      endUrl: "settings/transaction",
      data: data,
    );

    // log("Response from API: ${response} - $data");

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchSettingData();
        // SnackBars.showSuccessSnackBar(text: "Successfully Setting Saved");
      }
    }
    setLoadingValue(false);
  }

  Future<void> fetchSettingData() async {
    setLoadingValue(true);

    var response = await apiServices.getRequest(
        authToken: await SharedPreLocalStorage.getToken(),
        endurl: "settings/transaction");
    log("transaction settings : $response");
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        settingModel.value = TransactionSettingModel.fromJson(response.data);
        log("settings model \n settttings : ${settingModel.value}");
        if (settingModel.value.data != null) {
          Data? data = settingModel.value.data;
          enableDeliveryChallan.value = data!.enableDeliveryChallan ?? false;
          enableEstimate.value = data.enableEstimate ?? false;
          enableExportSales.value = data.enableExportSales ?? false;
          enableImportPurchase.value = data.enableImportPurchase ?? false;
          enablePartyEmail.value = data.enablePartyEmail ?? false;
          enablePurchaseOrder.value = data.enablePurchaseOrder ?? false;
          enableSalesOrder.value = data.enableSalesOrder ?? false;
          enableShippingAddress.value = data.enableShippingAddress ?? false;
        }
      }
    }
    setLoadingValue(false);
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchSettingData();
  }
}
