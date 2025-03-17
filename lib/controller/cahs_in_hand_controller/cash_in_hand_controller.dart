import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/cash_adjustment_list_model.dart';
import 'package:newthijar/model/cash_in_hand_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class CashInHandController extends GetxController {
  final ContextProvider _contextProvider = ContextProvider();
  final ApiServices _apiServices = ApiServices();
  // Reactive variables
  ApiServices apiServices = ApiServices();
  RxList allCash = <CashInHandModel>[].obs;
  // num currentBalance = 0;
  RxDouble currentCashBalance = 0.00.obs; // Example cash balance
  RxInt selectedRadioValue = 1.obs; // Radio button state for Add/Reduce Cash
  RxBool hasTransactions = true.obs; // Whether transactions exist or not

  // Method to toggle between add/reduce cash
  void setSelectedRadio(int value) {
    selectedRadioValue.value = value;
  }

  RxList<CashAdjustMentListModel> cashInhandList =
      <CashAdjustMentListModel>[].obs;
  // Method to simulate fetching transactions
  void fetchCashInHands() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
      endurl: EndUrl.cashInHand,
      authToken: await SharedPreLocalStorage.getToken(),
    );
    log("response : $response");
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<CashAdjustMentListModel> list = List<CashAdjustMentListModel>.from(
            jsonResponse.map((x) => CashAdjustMentListModel.fromJson(x)));

        cashInhandList.assignAll(list);
        log("Cash in hand list ==${cashInhandList.length}");
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  final adjustDateController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  void clearTextController() {
    adjustDateController.text = '';
    amountController.text = '';
    descriptionController.text = '';
  }

  bool isCashAdjustmentValidate() {
    if (adjustDateController.text.isEmpty || adjustDateController.text == '') {
      SnackBars.showErrorSnackBar(text: "Invalid Date");
      return false;
    } else if (amountController.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Invalid Amount");
      return false;
    } else {
      return true;
    }
  }

  void addCash() async {
    setLoadingValue(true);
    Map<String, dynamic> data = {
      "adjustmentType": selectedRadioValue.value == 1 ? 'Add' : 'Reduce',
      "adjustmentDate": adjustDateController.text,
      "amount": amountController.text,
      "description": descriptionController.text
    };
    var response = await _apiServices.postJsonData(
        endUrl: EndUrl.cashInHand,
        data: data,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchCashInHands();
        Get.back();
        // var jsonResponse = response.data['data'];
        SnackBars.showSuccessSnackBar(
            text:
                "Successfully ${selectedRadioValue.value == 1 ? 'Add Cash' : 'Reduce Cash'}");
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void updateCash({required String id}) async {
    setLoadingValue(true);
    Map<String, dynamic> data = {
      "adjustmentType": selectedRadioValue.value == 1 ? 'Add' : 'Reduce',
      "adjustmentDate": adjustDateController.text,
      "amount": amountController.text,
      "description": descriptionController.text
    };
    var response = await _apiServices.putJsonData(
        endUrl: EndUrl.cashInHand + id,
        data: data,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchCashInHands();
        Get.back();
        // var jsonResponse = response.data['data'];
        SnackBars.showSuccessSnackBar(
            text:
                "Successfully ${selectedRadioValue.value == 1 ? 'Add Cash' : 'Reduce Cash'}");
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void deleteCash({required String id}) async {
    setLoadingValue(true);

    var response = await _apiServices.deleteRequest(
        endurl: EndUrl.cashInHand + id,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchCashInHands();
        Get.back();
        // var jsonResponse = response.data['data'];
        SnackBars.showSuccessSnackBar(text: "Successfully deleted");
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCashInHands();
  }
}
