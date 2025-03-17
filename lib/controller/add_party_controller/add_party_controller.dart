import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/controller/transaction_detail_controller/transaction_detail_controller.dart';
import 'package:newthijar/model/credential_model.dart';
import 'package:newthijar/model/customer_party_model.dart';
import 'package:newthijar/model/party_model.dart';
import 'package:newthijar/model/party_transaction_detail_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class AddPartyController extends GetxController {
  final ApiServices _apiServices = ApiServices();

  RxBool gstinToggle = true.obs;
  RxBool partyShipToggle = true.obs;
  RxBool partyGroupingToggle = false.obs;
  RxBool inviteToggle = false.obs;
  RxBool isExpanded = false.obs; // State to track if dropdown is open
  // Map<String, bool> additionalFields = {
  //   "Additional Field 1": false,
  //   "Additional Field 2": false,
  //   "Additional Field 3": false,
  //   "Date Field": false,
  // }.obs;
  var partyDetailModel = PartyTransactionDetailModel().obs;
  RxBool isToPay = true.obs;

  final pNameController = TextEditingController();
  final pGstinController = TextEditingController();

  final contactNumController = TextEditingController();
  final openingBalanceController = TextEditingController();
  final asOfDateController = TextEditingController();
  final billingAddressController = TextEditingController();
  final shippingAddressController = TextEditingController();
  final emailController = TextEditingController();
  final homeController = Get.find<HomeController>();

  void clearPartyController() {
    pNameController.text = '';
    pGstinController.text = '';

    contactNumController.text = '';
    openingBalanceController.text = '';
    asOfDateController.text = '';
    billingAddressController.text = '';
    shippingAddressController.text = '';
    emailController.text = '';
  }

  RxBool isEditingParty = false.obs;
  bool validateParty() {
    if (pNameController.text.trim().isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please enter party name");
      return false;
      // }
      // else if (pGstinController.text.isEmpty) {
      //   SnackBars.showErrorSnackBar(text: "Please enter GSTIN");
      //   return false;
    } else {
      return true;
    }
  }

  RxString partyId = "".obs;

  void putAllPartyValues({required PartyModel model}) {
    isEditingParty.value = true;
    partyId.value = model.id.toString();
    if (model.contactDetails != null) {
      contactNumController.text = model.contactDetails!.phone.toString();
      emailController.text = model.contactDetails!.email.toString();
    }
    pNameController.text = model.name.toString();

    pGstinController.text = model.gstIn.toString();
    if (model.openingBalanceDetails != null) {
      openingBalanceController.text =
          model.openingBalanceDetails!.openingBalance.toString();
      isToPay.value =
          model.openingBalanceDetails!.balanceType.toString() == "toPay"
              ? true
              : false;
    }
    asOfDateController.text = '';
    billingAddressController.text = model.billingAddress.toString();
    shippingAddressController.text = model.shippingAddress.toString();
  }

  void deleteParty({required String id}) async {
    setLoadingValue(true);

    var response = await _apiServices.deleteRequest(
        endurl: EndUrl.addParty + id,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        final controller = Get.find<HomeController>();
        controller.getAllParty();
        Get.back();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Deleted Party");
      }
    }

    setLoadingValue(false);
  }

  RxList<CustomerPartyModelList> filteredCPlist =
      <CustomerPartyModelList>[].obs;
  RxList<CustomerPartyModelList> customerPartyNmList =
      <CustomerPartyModelList>[].obs;
  void filterCustomer({String? name}) {
    if (name == null || name.isEmpty) {
      // filteredCPlist.assignAll(customerPartyNmList);
      filteredCPlist.assignAll(customerPartyNmList);
      return;
    }

    var filteredList = customerPartyNmList.where((customer) {
      return customer.name != null &&
          customer.name!.toLowerCase().startsWith(name.toLowerCase());
    }).toList();

    filteredCPlist.assignAll(filteredList);
    // customerPartyNmList.value = filteredList;
  }

  fetchCustomerParty() async {
    //  setLoadingValue(true);

    var response = await _apiServices.getRequest(
        endurl: EndUrl.getAllParty,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<CustomerPartyModelList> units = List<CustomerPartyModelList>.from(
            jsonResponse.map((x) => CustomerPartyModelList.fromJson(x)));

        customerPartyNmList.assignAll(units);
      }
    }
  }

  void addParty() async {
    final itemName = pNameController.text.trim();

    // Check if the item already exists in the list
    bool itemExists = homeController.allParties
        .any((item) => item.name!.toLowerCase() == itemName.toLowerCase());

    if (itemExists) {
      SnackBars.showErrorSnackBar(text: "Party already exists in the list.");
      return;
    }
    CredentialModel credentialModel =
        await SharedPreLocalStorage.getCredential();
    setLoadingValue(true);

    var data = {
      "name": pNameController.text,
      "gstIn": pGstinController.text,
      "gstType": "Unregistered/Consumer",
      "email": emailController.text,
      "phone": contactNumController.text,
      "state": "",
      "billingAddress": billingAddressController.text,
      "shippingAddress": shippingAddressController.text,
      "openingBalance": openingBalanceController.text,
      "asOfDate": asOfDateController.text,
      "balanceType": isToPay.value ? "toPay" : "toReceive",
      "additionalField1": "",
      "additionalField2": "",
      "additionalField3": ""
    };
    var response = await _apiServices.postJsonData(
        data: data, endUrl: EndUrl.addParty, authToken: credentialModel.token);
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var hC = Get.find<HomeController>();
        var tC = Get.put(TransactionDetailController());
        hC.getAllParty();
        tC.fetchCustomerParty();
        fetchCustomerParty();
        clearPartyController();
        Get.back();
        // Get.back();
        SnackBars.showSuccessSnackBar(text: "Added Party");
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void updateParty() async {
    log("This is update party");
    // final itemName = pNameController.text.trim();

    // Check if the item already exists in the list
    // bool itemExists = homeController.allParties
    //     .any((item) => item.name!.toLowerCase() == itemName.toLowerCase());

    // if (itemExists) {
    //   SnackBars.showErrorSnackBar(text: "Party already exists in the list.");
    //   return;
    // }

    setLoadingValue(true);

    var data = {
      "name": pNameController.text,
      "gstIn": pGstinController.text,
      "gstType": "Unregistered/Consumer",
      "email": emailController.text,
      "phone": contactNumController.text,
      "state": "",
      "billingAddress": billingAddressController.text,
      "shippingAddress": shippingAddressController.text,
      "openingBalance": openingBalanceController.text,
      "asOfDate": asOfDateController.text,
      "balanceType": isToPay.value ? "toPay" : "toReceive",
      "additionalField1": "",
      "additionalField2": "",
      "additionalField3": ""
    };
    var response = await _apiServices.putJsonData(
        data: data,
        endUrl: EndUrl.addParty + partyId.value,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var hC = Get.find<HomeController>();
        hC.getAllParty();
        fetchCustomerParty();
        clearPartyController();
        Get.back();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Saved Party");
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  Future<void> getPartyTransactionDetail({required String id}) async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
        endurl: EndUrl.getPartyTransactions + id,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        // var jsonResponse = response.data['data'];

        PartyTransactionDetailModel model =
            PartyTransactionDetailModel.fromJson(response.data);
        partyDetailModel.value = model;

        // printInfo(info: "length of invoices ==${list.length}");
        log("partyDetailModel ====${partyDetailModel.value.data!.length}");
        log("partyDetailModel ====${partyDetailModel.value.data!.length}");
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  @override
  void onInit() {
    super.onInit();
    fetchCustomerParty();
  }
}
