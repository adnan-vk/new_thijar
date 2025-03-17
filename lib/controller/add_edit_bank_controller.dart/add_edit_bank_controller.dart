import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newthijar/controller/bank_account_controller/bank_account_controller.dart';
import 'package:newthijar/model/add_bank_model.dart';
import 'package:newthijar/model/edit_bank_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/bank_service.dart';
import 'package:newthijar/service/edit_bank_servoce.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class AddEditBankAccountController extends GetxController {
  final BankService _bankService = BankService();
  final EditBankService _editBankService = EditBankService();
  final ApiServices apiservice = ApiServices();
  Dio dio = Dio();

  var printBankDetails = false.obs;
  var printUPIQR = false.obs;
  var selectedDate = DateTime.now().obs;
  RxString bankId = ''.obs;
  final dateController = TextEditingController();
  final openingBalanceController = TextEditingController();
  final accountHolderCont = TextEditingController();
  final accountNumberCon = TextEditingController();
  final ifscCodeController = TextEditingController();
  final branchContr = TextEditingController();
  final upiIdOrqContr = TextEditingController();
  TextEditingController accountNameContr = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate.value);
  }

  void clearControllers() {
    accountNameContr.clear();
    openingBalanceController.clear();
    dateController.clear();
    accountHolderCont.clear();
    accountNumberCon.clear();
    ifscCodeController.clear();
    branchContr.clear();
    upiIdOrqContr.clear();
    printBankDetails.value = false;
    printUPIQR.value = false;
    selectedDate.value = DateTime.now();
  }

  void putBankDetail() async {
    var controller = Get.put(BankAccountsController());
    var bankDetail = controller.bankDetail.value;
    bankId.value = bankDetail!.id;
    accountNameContr.text = bankDetail.accountHolderName.toString();

    openingBalanceController.text = bankDetail.openingBalance.toString();
    dateController.text = bankDetail.asOfDate.toString();
    printBankDetails.value = bankDetail.printBankDetailsOnInvoice;
    printUPIQR.value = bankDetail.printUPIQRCodeOnInvoice;
    upiIdOrqContr.text = bankDetail.upiIDForQRCode.toString();
    accountHolderCont.text = bankDetail.accountHolderName.toString();
    accountNumberCon.text = bankDetail.accountNumber.toString();
    ifscCodeController.text = bankDetail.ifscCode.toString();
    branchContr.text = bankDetail.branchName.toString();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  String saleValidator() {
    if (accountNameContr.text.trim().isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please enter bank name");
      return "Please enter bank name";
    } else if (openingBalanceController.text.trim().isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please enter opening balance");
      return "Please enter opening balance";
    } else if (accountHolderCont.text.trim().isEmpty) {
      SnackBars.showErrorSnackBar(text: "Account holder name is empty");
      return "Empty";
    } else if (ifscCodeController.text.trim().isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please enter IFSC code");
      return "Please enter IFSC code";
    } else {
      return "ok";
    }
  }

  Future<void> addBankAccount() async {
    if (saleValidator() != 'ok') return;

    final bankModel = AddBankModel(
      accountDisplayName: accountNameContr.text,
      openingBalance: int.parse(openingBalanceController.text),
      asOfDate: selectedDate.value,
      printUpiqrCodeOnInvoice: printUPIQR.value,
      printBankDetailsOnInvoice: printBankDetails.value,
      accountNumber: accountNumberCon.text,
      ifscCode: ifscCodeController.text,
      upiIdForQrCode: upiIdOrqContr.text,
      branchName: branchContr.text,
      accountHolderName: accountHolderCont.text,
    );

    try {
      // Ensure the token is awaited properly
      final authToken = await SharedPreLocalStorage.getToken();
      if (authToken == null || authToken.isEmpty) {
        throw Exception("Token is null or empty");
      }

      final response = await _bankService.addBank(bankModel, authToken);
      log("bankname in controller : $accountNameContr");
      log("bank added : $response");
      clearControllers();
      Get.back();
      Get.snackbar("Success", "Bank account added successfully",
          backgroundColor: Colors.green);
    } catch (e) {
      log("Error in addBankAccount: $e");
      Get.snackbar("Error", "Failed to add bank account",
          backgroundColor: Colors.red);
    }
  }

  void editBankAccount() async {
    log("This is edit bank ");
    setLoadingValue(true);
    final editBankModel = EditBankModel(
      accountDisplayName: accountNameContr.text,
      openingBalance: int.tryParse(openingBalanceController.text),
      asOfDate: selectedDate.value,
      printUpiqrCodeOnInvoice: printUPIQR.value,
      printBankDetailsOnInvoice: printBankDetails.value,
      accountNumber: accountNumberCon.text,
      ifscCode: ifscCodeController.text,
      upiIdForQrCode: upiIdOrqContr.text,
      branchName: branchContr.text,
      accountHolderName: accountHolderCont.text,
    );

    try {
      var response = await apiservice.putJsonData(
          authToken: await SharedPreLocalStorage.getToken(),
          endUrl: 'bank/' + bankId.value,
          data: editBankModel.toJson());

      if (response != null) {
        printInfo(info: "response to save invoice==$response");
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          Get.back();
          SnackBars.showSuccessSnackBar(text: "Successfully saved invoice");

          setLoadingValue(false);
        }
        setLoadingValue(false);
      }
      setLoadingValue(false);
    } catch (e) {
      setLoadingValue(false);
      Get.snackbar("Error", "Failed to update bank account",
          backgroundColor: Colors.red);
    }
  }

  void deleteSaleById({required String id}) async {
    setLoadingValue(true);

    var response = await apiservice.deleteRequest(
        endurl: 'bank/' + bankId.value,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Deleted bank");
      }
    }

    setLoadingValue(false);
  }

  void initializeFields(AddBankModel bankData) {
    accountNameContr.text = bankData.accountDisplayName ?? '';
    openingBalanceController.text = bankData.openingBalance?.toString() ?? '0';
    selectedDate.value = bankData.asOfDate ?? DateTime.now();
    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    printUPIQR.value = bankData.printUpiqrCodeOnInvoice ?? false;
    printBankDetails.value = bankData.printBankDetailsOnInvoice ?? false;
    accountNumberCon.text = bankData.accountNumber ?? '';
    ifscCodeController.text = bankData.ifscCode ?? '';
    upiIdOrqContr.text = bankData.upiIdForQrCode ?? '';
    branchContr.text = bankData.branchName ?? '';
    accountHolderCont.text = bankData.accountHolderName ?? '';
  }

  Future<EditBankModel> getBankDetails(String bankId) async {
    final response = await dio.get('https://your-api-endpoint/banks/$bankId');
    return EditBankModel.fromJson(response.data);
  }
}
