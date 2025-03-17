// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/model/cash_flow_report_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class CashFlowReportController extends GetxController
    with SingleGetTickerProviderMixin {
  final ApiServices _apiServices = ApiServices();
  Rx<CashFlowReportModel> cashFlowReportList = CashFlowReportModel().obs;
  late TabController tabController;
  RxBool isMoneyIn = true.obs; // Reactive variable
  RxnNum moneyInTotal = RxnNum(0);
  RxnNum moneyOutTotal = RxnNum(0);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      isMoneyIn.value = tabController.index == 0;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // void fetchCashFlowReportList() async {
  //   setLoadingValue(true);

  //   var response = await _apiServices.getRequest(
  //       endurl: "reports/cash-flow?fromDate=2024-12-01&toDate=2024-12-30",
  //       authToken: await SharedPreLocalStorage.getToken());
  //   // log("response status code ==  $response");
  //   if (response != null) {
  //     if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
  //       var jsonResponse = response.data['TransactionList'];

  //       List<CashFlowReportModel> units = List<CashFlowReportModel>.from(
  //           jsonResponse.map((x) => CashFlowReportModel.fromJson(x)));

  //       setLoadingValue(false);
  //       cashFlowReportList.assignAll(units);
  //       // log("Items = $cashFlowReportList");
  //       setLoadingValue(false);
  //     }
  //     setLoadingValue(false);
  //   }
  //   setLoadingValue(false);
  // }

  Future<void> fetchCashFlowReportList({
    required DateFilterModel date,
  }) async {
    try {
      setLoadingValue(true);
      moneyInTotal.value = 0.0;
      moneyOutTotal.value = 0.0;
      cashFlowReportList = CashFlowReportModel().obs;
      var response = await _apiServices.getRequest(
        endurl:
            "reports/cash-flow/mobile?fromDate=${date.startDate}&toDate=${date.endDate}",
        authToken: await SharedPreLocalStorage.getToken(),
      );
      log("response of cash flow : $response");
      if (response != null &&
          CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];
        if (jsonResponse != null) {
          CashFlowReportModel model = CashFlowReportModel.fromMap(jsonResponse);
          cashFlowReportList.value = model;
          moneyInTotal.value = model.moneyIn?.fold(
                  0,
                  (previousValue, element) =>
                      (previousValue ?? 0) + (element.creditAmount ?? 0)) ??
              0.0;
          moneyOutTotal.value = model.moneyOut?.fold(
                  0,
                  (previousValue, element) =>
                      (previousValue ?? 0) + (element.debitAmount ?? 0)) ??
              0.0;
        }
      } else {
        log("API response is null or invalid");
      }
    } catch (e) {
      log("Error fetching cash flow report: $e");
    } finally {
      setLoadingValue(false);
    }
  }
}
