import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/model/all_payment_in_model.dart';
import 'package:newthijar/model/bank_model_list.dart';
import 'package:newthijar/model/customer_party_model.dart';
import 'package:newthijar/model/reciept_number_model.dart';
import 'package:newthijar/model/state_model.dart';
import 'package:newthijar/model/tax_model.dart';
import 'package:newthijar/model/unit_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class PaymentInController extends GetxController {
  final ContextProvider _contextProvider = ContextProvider();
  final ApiServices _apiServices = ApiServices();
  RxList allTransaction = <AllPaymentInModel>[].obs;
  bool isLoading = false; // Change this to true when data is fetched
  bool hasData = false; // Change this to true when data is fetched

  RxString selectedSaleDate = "9/20/2024".obs;
  // RxString selectedPaymentType = "Cash".obs;

  var selectedState = StateModel().obs;
  var selectedTax = TaxModel(taxType: "None", rate: '0.0').obs;

  RxString isTaxOrNo = 'Without Tax'.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedSaleType = 'Credit'.obs;
  var invoiceNo = RecieptNoModel().obs;

  //Editing
  RxBool yourEditingPayment = false.obs;
  RxString forEditDate = "".obs;
  RxString forEditCustomerName = "".obs;
  RxString forEditInvoiceNumber = "".obs;
  RxString forEditPhoneNumber = "".obs;
  RxString forReceivedAmount = "".obs;
  RxString forTotalAmount = "".obs;
  RxString forEditingId = "".obs;

  //addItem

  // RxString selectedUnit = 'Unit'.obs;

  // RxString selectedTax = 'Without Tax'.obs;
  RxBool isPriceEntered = false.obs;
  //  ValueNotifier<RxDouble> receivedAmountNotifier = ValueNotifier(0.0.obs);
  final TextEditingController recivedAmountController = TextEditingController();
  final itemNameContr = TextEditingController();
  final quantityContr = TextEditingController();
  final priceContr = TextEditingController();
  final discountContr = TextEditingController();
  final totalAmountContr = TextEditingController();

  final referenceNoContr = TextEditingController();
  final descriptionContr = TextEditingController();
  final customerTxtCont = TextEditingController();
  final phoneNumberController = TextEditingController();
  final receivedController = TextEditingController();

  RxDouble subTotalP = 0.0.obs;
  RxDouble totalPrice = 0.0.obs;
  RxDouble totalDiscount = 0.0.obs;
  RxDouble totalTaxes = 0.0.obs;

  RxList unitList = <UnitModel>[].obs;
  RxList stateList = <StateModel>[].obs;
  RxList taxList = <TaxModel>[].obs;

  RxList<CustomerPartyModelList> filteredCPlist =
      <CustomerPartyModelList>[].obs;
  RxList<CustomerPartyModelList> customerPartyNmList =
      <CustomerPartyModelList>[].obs;
  Rxn<CustomerPartyModelList> selectedCustomer = Rxn();
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

  //bank

  RxString selectedPayableMethod = 'Cash'.obs;
  var selectedPaymentType = BankModelList(accountHolderName: "Cash").obs;
  //bank details

  RxList<BankModelList> bankList = <BankModelList>[].obs;

  Future<void> fetchBankList() async {
    //  setLoadingValue(true);

    var response = await _apiServices.getRequest(
        endurl: EndUrl.bank, authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<BankModelList> list = List<BankModelList>.from(
            jsonResponse.map((x) => BankModelList.fromJson(x)));

        bankList.assignAll(list);
      }
    }
    log("Bank list length ==${bankList.length}");
  }

  RxBool printBankDetails = false.obs;
  RxBool printUPIQR = false.obs;

  TextEditingController acountNameContr = TextEditingController();
  TextEditingController openingBalanceContr = TextEditingController();
  TextEditingController asOnContr = TextEditingController();
  TextEditingController accountHolderCont = TextEditingController();
  TextEditingController accountNumCont = TextEditingController();
  TextEditingController ifscCodeCont = TextEditingController();
  TextEditingController branchNameCont = TextEditingController();
  TextEditingController upiIdCont = TextEditingController();

  bool checkIsFormValidate() {
    if (acountNameContr.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please Enter Account Display Name");
      return false;
    } else if (openingBalanceContr.text.isEmpty ||
        double.parse(openingBalanceContr.text) <= 0) {
      SnackBars.showErrorSnackBar(text: "Please Enter Opening Balance");
      return false;
    } else if (accountHolderCont.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please Enter Account Holder Name");
      return false;
    } else if (accountNumCont.text.isEmpty || accountNumCont.text.length <= 9) {
      SnackBars.showErrorSnackBar(text: "Please Enter Valid Account Number");
      return false;
    } else if (branchNameCont.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please Enter Branch Name");
      return false;
    } else {
      return true;
    }
  }

  void clearBankControllers() {
    acountNameContr.text = '';
    openingBalanceContr.text = '';
    asOnContr.text = '';

    accountNumCont.text = '';
    ifscCodeCont.text = '';
    upiIdCont.text = '';
    branchNameCont.text = '';
    accountHolderCont.text = '';
  }

  void addBank() async {
    setLoadingValue(true);
    var body = {
      "accountDisplayName": acountNameContr.text,
      "openingBalance": openingBalanceContr.text,
      "asOfDate": asOnContr.text,
      "printUPIQRCodeOnInvoice": bool.parse(printUPIQR.toString()),
      "printBankDetailsOnInvoice": bool.parse(printBankDetails.toString()),
      "accountNumber": accountNumCont.text,
      "ifscCode": ifscCodeCont.text.isEmpty ? '' : ifscCodeCont.text,
      "upiIDForQRCode": upiIdCont.text,
      "branchName": branchNameCont.text,
      "accountHolderName": accountHolderCont.text
    };
    var response = await _apiServices.postJsonData(
        authToken: await SharedPreLocalStorage.getToken(),
        endUrl: EndUrl.bank,
        data: body);

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        await fetchBankList();
        clearBankControllers();
        setLoadingValue(false);
        Get.back();
        showPaymentTypeBottom(
            onClickClose: () => Get.back(),
            payableMethod: (p0) {
              selectedPayableMethod.value = p0;
            },
            // onClickCash: () => _controller.setPaymentType("Cash"),
            // onClickCheque: () => _controller.setPaymentType("Cheque"),
            bankList: bankList,
            onSelectItem: (p0) {
              selectedPaymentType.value = p0;
            },
            onClickAddBank: () {
              Get.back();
              // Get.to(() => AddBankScreen());
            });
        SnackBars.showSuccessSnackBar(text: "Saved Bank Detail");
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  @override
  void onInit() {
    DateController dateController = Get.put(DateController());
    selectedSaleDate.value = ContextProvider().getCurrentDate();
    asOnContr.text = ContextProvider().getCurrentDate();
    super.onInit();
    fetchInvoicNo();
    getAllTransaction(
        date: DateFilterModel(
            startDate: dateController.startDateIs.value,
            endDate: dateController.endDateIs.value));
    fetchBankList();
    fetchCustomerParty();
    // fetchUnitList();
    // setLoadingValue(false);
  }

  void setSaleFormType(index) {
    if (index == 0) {
      selectedSaleType.value = 'Credit';
    } else {
      selectedSaleType.value = 'Cash';
    }
  }

  RxDouble grandSubTotal = 0.0.obs;
  RxDouble grandTax = 0.0.obs;
  RxDouble grandQty = 0.0.obs;
  RxDouble grandDiscount = 0.0.obs;
  double totalTax = 0.0;
  double totalQty = 0.0;
  double subTotals = 0.0;

  List<File?> fileList = [null, null];
  List<String?> fileNames = [null, null];
  RxString documentName = ''.obs;
  RxString imgPath = ''.obs;

  RxBool isChecked = false.obs;

  void fetchInvoicNo() async {
    var response = await _apiServices.getRequest(
        endurl: EndUrl.paymentInRecieptNo,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        RecieptNoModel ob = RecieptNoModel(
            id: response.data['data']['_id'],
            paymentOutReceiptNo: response.data['data']['paymentInReceiptNo']);
        invoiceNo.value = ob;
      }
    }
  }

  void fetchStates() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
        endurl: EndUrl.statesUrl,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<StateModel> list = List<StateModel>.from(
            jsonResponse.map((x) => StateModel.fromJson(x)));

        stateList.assignAll(list);

        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void fetchTax() async {
    setLoadingValue(true);
    var response = await _apiServices.getRequest(
        endurl: EndUrl.taxUrl,
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];
        if (jsonResponse != null) {
          List<TaxModel> list = List<TaxModel>.from(
              jsonResponse.map((x) => TaxModel.fromJson(x)));

          taxList.assignAll(list);
        } else {
          taxList.assignAll([]);
          SnackBars.showAlertSnackBar(
              text: "Please enable VAT or GST to retrieve the tax rates list.");
        }
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  RxDouble balanceDue = 0.0.obs;

  void setPaymentType(value) {
    selectedPaymentType.value = value;
    Get.back();
  }

  void chooseImage() async {
    FileDetails? fileDetail =
        await _contextProvider.selectFile(allowedExtensions: [
      'jpg',
      'jpeg',
      'png',
    ]);
    if (fileDetail != null) {
      fileList[0] = File(fileDetail.filePath.toString());
      fileNames[0] = fileDetail.fileName;
      imgPath.value = fileDetail.filePath.toString();
    }
  }

  void chooseDocument() async {
    FileDetails? fileDetail =
        await _contextProvider.selectFile(allowedExtensions: [
      'pdf', // PDF files
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
    ]);
    if (fileDetail != null) {
      fileList[1] = File(fileDetail.filePath.toString());
      fileNames[1] = fileDetail.fileName;
      documentName.value = fileDetail.fileName.toString();
    }
  }

  String saleValidator() {
    if (customerTxtCont.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please enter customer");
      return "Please enter customer";
    } else if (invoiceNo.value.paymentOutReceiptNo == null) {
      SnackBars.showErrorSnackBar(text: "Empty receipt number");
      return "Empty receipt number";
    }
    //  else if (descriptionContr.text.isEmpty) {
    //   SnackBars.showErrorSnackBar(text: "Please enter description");
    //   return "Please enter description";
    // } else if (selectedState.value.id == null) {
    //   SnackBars.showErrorSnackBar(text: "Please select state");
    //   return "Please select state";
    // }

    else if (selectedPaymentType.value == '') {
      SnackBars.showErrorSnackBar(text: "Please select payment method");
      return "Please select payment method";
    } else {
      return "ok";
    }
  }

  void addSale() async {
    DateController dateController = Get.put(DateController());
    setLoadingValue(true);
    List<Map<String, dynamic>> paymentType = [
      {
        "method": selectedPayableMethod.value,
        "amount": grandSubTotal.value.toStringAsFixed(2).toString(),
        "bankName": selectedPaymentType.value.id,
        "referenceNo": referenceNoContr.text
      }
    ];

    dio.FormData formData = dio.FormData.fromMap({
      'receiptNo': invoiceNo.value.paymentOutReceiptNo.toString(),
      'date': selectedSaleDate.value.toString(),
      'phoneNo': phoneNumberController.text,
      'party': customerTxtCont.text,
      'stateOfSupply': selectedState.value.id == null
          ? ''
          : selectedState.value.id.toString(),
      'description': descriptionContr.text,
      'totalAmount': totalAmountContr.text,
      'receivedAmount':
          double.parse(receivedController.text).toStringAsFixed(2).toString(),
    });
    formData.fields.add(MapEntry('paymentMethod', jsonEncode(paymentType)));

    List<String> parameters = ["files", "files"];

    if (fileList.length.toInt() >= 1) {
      for (int i = 0; i < parameters.length; i++) {
        if (fileList[i] != null) {
          String fileName = fileList[i]!.path.split('/').last;
          formData.files.add(
            MapEntry(
              parameters[i],
              await dio.MultipartFile.fromFile(fileList[i]!.path,
                  filename: fileName),
            ),
          );
        }
      }
    }
    var response = await _apiServices.postMultiPartData(
        data: formData,
        // fileParameters: parameters,
        files: fileList,
        endUrl: EndUrl.createPayIn,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      printInfo(info: "response to save invoice==$response");
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchInvoicNo();
        getAllTransaction(
            date: DateFilterModel(
                startDate: dateController.startDateIs.value,
                endDate: dateController.endDateIs.value));
        customerTxtCont.clear();
        phoneNumberController.clear();
        Get.back();

        Get.snackbar("Successfully saved payment in", "",
            backgroundColor: Colors.green);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  updateSale(paymentId) async {
    DateController dateController = Get.put(DateController());
    setLoadingValue(true);
    List<Map<String, dynamic>> paymentType = [
      {
        "method": selectedPayableMethod.value,
        "amount": grandSubTotal.value.toStringAsFixed(2).toString(),
        "bankName": selectedPaymentType.value.id,
        "referenceNo": referenceNoContr.text
      }
    ];

    dio.FormData formData = dio.FormData.fromMap({
      'receiptNo': invoiceNo.value.paymentOutReceiptNo.toString(),
      'phoneNo': phoneNumberController.text,
      'date': selectedSaleDate.value.toString(),
      'party': customerTxtCont.text,
      'stateOfSupply': selectedState.value.id == null
          ? ''
          : selectedState.value.id.toString(),
      'description': descriptionContr.text,
      'totalAmount': totalAmountContr.text,
      'receivedAmount':
          double.parse(receivedController.text).toStringAsFixed(2).toString(),
    });
    formData.fields.add(MapEntry('paymentMethod', jsonEncode(paymentType)));

    List<String> parameters = ["files", "files"];

    if (fileList.length.toInt() >= 1) {
      for (int i = 0; i < parameters.length; i++) {
        if (fileList[i] != null) {
          String fileName = fileList[i]!.path.split('/').last;
          formData.files.add(
            MapEntry(
              parameters[i],
              await dio.MultipartFile.fromFile(fileList[i]!.path,
                  filename: fileName),
            ),
          );
        }
      }
    }

    var response = await _apiServices.putMultiPartData(
        data: formData,
        // fileParameters: parameters,
        files: fileList,
        endUrl: EndUrl.updatePaymentIn + paymentId.value,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      printInfo(info: "response to save invoice==$response");
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        // var homec = Get.find<HomeController>();
        fetchInvoicNo();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully saved invoice");
        getAllTransaction(
            date: DateFilterModel(
                startDate: dateController.startDateIs.value,
                endDate: dateController.endDateIs.value));
        // homec.getAllInvoice();
        setLoadingValue(false);
      }

      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void getAllTransaction({
    required DateFilterModel date,
  }) async {
    try {
      allTransaction.clear();
      setLoadingValue(true);
      var response = await _apiServices.getRequest(
        endurl: 'paymentIn/',
        authToken: await SharedPreLocalStorage.getToken(),
      );
      setLoadingValue(false);
      log("response ==$response");
      if (response!.statusCode == 200) {
        hasData = true;
      } else {
        hasData = false;
      }
      isLoading = !isLoading;
      log("response in get all transaction : $response");
      log("allTransaction in get all transaction : ${allTransaction.length}");
      List jsonData = response.data['data'];
      List<AllPaymentInModel> list =
          jsonData.map((x) => AllPaymentInModel.fromJson(x)).toList();
      allTransaction.assignAll(list);
    } catch (e) {
      log("error in allTransaction summery controller $e");
    }
  }
}
