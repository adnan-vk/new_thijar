import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/controller/payment_in_controller/payment_in_controller.dart';
import 'package:newthijar/controller/sale_inv_report_controller/sale_inv_report_controller.dart';
import 'package:newthijar/model/bank_model_list.dart';
import 'package:newthijar/model/customer_party_model.dart';
import 'package:newthijar/model/invoive_no_model.dart';
import 'package:newthijar/model/item_model.dart';
import 'package:newthijar/model/manage_godown_model.dart';
import 'package:newthijar/model/sale_detail_model.dart';
import 'package:newthijar/model/sale_detail_model_edit.dart';
import 'package:newthijar/model/state_model.dart';
import 'package:newthijar/model/tax_model.dart';
import 'package:newthijar/model/unit_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/godown_service.dart';
import 'package:newthijar/service/pdf_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/view/add_bank_screen/add_bank_screen.dart';
import 'package:newthijar/view/home_page/widgets/item_card_widget.dart';
import 'package:newthijar/view/pdf_page/pdf_screen.dart';
import 'package:newthijar/view/sale/sub_screen/add_sale_invoice_screen/add_sale_invoice_screen.dart';
import 'package:newthijar/view/sale/sub_screen/sale_invoice_list/sale_invoice_list.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class TransactionDetailController extends GetxController {
  final ContextProvider _contextProvider = ContextProvider();
  final ApiServices _apiServices = ApiServices();

  RxString country = "Select Country".obs;
  RxString currency = "Select Currency".obs;
  var conversionRate = 1.0.obs; // Default value
  var priceForBaseUnit = 0.0.obs;
  var isSecondaryChoosed = false.obs; // Default value
  var unitNames = <Map<String, dynamic>>[].obs;
  var secondaryUnitName = ''.obs;
  var primaryUnitName = ''.obs;

  void clearItemControllerWithoutItemName() {
    isEditingItem.value = false;
    // itemNameContr.text = '';
    quantityContr.text = '';
    priceContr.text = '';
    discountContr.text = '';
    totalAmountContr.text = '';
    subTotalP.value = 0.0;
    totalDiscount.value = 0.0;
    selectedTax.value;
    // selectedTax.value = TaxModel(taxType: "None", rate: '0.0');
    totalTaxes.value = 0.0;
  }

  RxString selectedSaleDate = "".obs;
  final String defaultDate = DateFormat('yyyy-MM-yy').format(DateTime.now());
  var selectedPaymentType = BankModelList(accountHolderName: "Cash").obs;
  RxBool youRedting = false.obs;
  RxString saleId = ''.obs;
  var selectedState = StateModel().obs;
  var selectedTax = TaxModel(taxType: "None", rate: '0.0').obs;
  var isMRPEnabled = true.obs;

  RxString isTaxOrNo = 'Without Tax'.obs;
  RxInt selectedIndex = 0.obs;
  RxString selectedSaleType = 'Credit'.obs;
  var unitModel = UnitModel().obs;
  var invoiceNo = InvoiceNoModel().obs;
  var saleDetailModel = SaleDetailModel().obs;
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxList<CustomerPartyModelList> customerPartyNmList =
      <CustomerPartyModelList>[].obs;
  RxList<BankModelList> bankList = <BankModelList>[].obs;
  // RxList<CustomerPartyModelList> filteredCPlist = <CustomerPartyModelList>[].obs;
  Rxn<CustomerPartyModelList> selectedCustomer = Rxn();
  void deleteItem(int index) {
    log("${itemList.length}");

    itemList.removeAt(index);
    log("${itemList.length}");
  }

  RxBool addUnitEnable = false.obs;

  final unitNameController = TextEditingController();
  final unitShortNameContr = TextEditingController();

  final saleController = Get.put(SaleInvoiceOrReportController());

  // void filterCustomer({String? name}) {
  //   log("CustomerParty list ==${customerPartyNmList.length}");
  //   if (name == null || name.isEmpty) {
  //     // filteredCPlist.assignAll(customerPartyNmList);
  //     filteredCPlist.assignAll(customerPartyNmList);
  //     return;
  //   }
  //
  //   var filteredList = customerPartyNmList.where((customer) {
  //     return customer.name != null && customer.name!.toLowerCase().startsWith(name.toLowerCase());
  //   }).toList();
  //
  //   filteredCPlist.assignAll(filteredList);
  //   log("Filtered list ==${filteredCPlist.length}");
  //   // customerPartyNmList.value = filteredList;
  // }

  RxBool isEditingItem = false.obs;
  RxBool isEditingFromSalesInvoice = false.obs;
  RxInt itemIndex = 0.obs;
  void updateItemValues({required ItemModel object, required int index}) {
    itemIndex.value = index;
    isEditingItem.value = true;
    itemNameContr.text = object.itemName.toString();
    quantityContr.text = object.quantity.toString();
    unitModel.value.name = object.unit;
    priceContr.text = object.price.toString();
    discountContr.text = object.discountP.toString();
    totalDiscount.value = double.parse(
        object.discount != null ? object.discount.toString() : "0");
    // Get.to(
    //   () => AddItemToSale(
    //     itemIndex: index,
    //   ),
    // );

    if (discountContr.text != '') {
      calculateTotalAmount(
          price: double.parse(priceContr.text),
          quantity: double.parse(
              quantityContr.text == '' ? '1.0' : quantityContr.text),
          discountPercentage:
              discountContr.text == '' ? 0.0 : double.parse(discountContr.text),
          taxPercentage: double.parse(selectedTax.value.rate.toString()));
    } else {
      calculateTotalAmount(
          price: double.parse(priceContr.text),
          quantity: double.parse(
              quantityContr.text == '' ? '1.0' : quantityContr.text),
          taxPercentage: double.parse(selectedTax.value.rate.toString()));
    }
  }

  //fetch godown names
  final itemLocationCont = TextEditingController();
  var selectedLocation = ''.obs; // Initialize with an empty string
  var locationList = ['Error', 'Error'].obs;
  RxList<Datas> allGodowns = <Datas>[].obs;
  RxList<String> godownNames = <String>[].obs;
  final GodownService _service = GodownService();
  fetchAllGodowns() async {
    try {
      setLoadingValue(true);

      allGodowns.value = await _service.fetchGodowns();

      // Ensure godownNames updates correctly
      godownNames
          .assignAll(allGodowns.map((godown) => godown.id).whereType<String>());

      // Ensure locationList updates correctly
      locationList.assignAll(godownNames);

      setLoadingValue(false);
    } catch (e) {
      log("error in godown controller : $e");
    }
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
    // log("Bank list length ==${bankList.length}");
  }
  // RxString selectedUnit = 'Unit'.obs;

  // RxString selectedTax = 'Without Tax'.obs;
  RxBool isPriceEntered = false.obs;
  ValueNotifier<RxDouble> receivedAmountNotifier = ValueNotifier(0.0.obs);
  final TextEditingController recivedAmountController = TextEditingController();
  final itemNameContr = TextEditingController();
  final quantityContr = TextEditingController();
  final priceContr = TextEditingController();
  final mrpContr = TextEditingController();
  final discountContr = TextEditingController();
  final totalAmountContr = TextEditingController();
  final referenceNoContr = TextEditingController();
  final descriptionContr = TextEditingController();
  final customerTxtCont = TextEditingController();
  final phoneNumberController = TextEditingController();
  final currentRecivedAmountController = TextEditingController();
  RxList<String> itemListString = <String>[].obs;
  RxDouble subTotalP = 0.0.obs;
  RxDouble totalPrice = 0.0.obs;
  RxDouble totalDiscount = 0.0.obs;
  RxDouble totalTaxes = 0.0.obs;

  RxList unitList = <UnitModel>[].obs;
  RxList stateList = <StateModel>[].obs;
  RxList<TaxModel> taxList = <TaxModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    // ever(isTaxOrNo, (value) => print("Updated Value: $value"));
    selectedSaleDate.value = ContextProvider().getCurrentDate();
    asOnContr.text = ContextProvider().getCurrentDate();
    fetchInvoicNo();
    fetchCustomerParty();
    fetchBankList();
    fetchAllGodowns();
    // fetchUnitList();
    // setLoadingValue(false);
  }

  clearController() {
    selectedCustomer.value = null;
    itemList.clear();
    itemNameContr.clear();
    quantityContr.clear();
    priceContr.clear();
    discountContr.clear();
    totalAmountContr.clear();
    unitNameController.clear();
    unitShortNameContr.clear();
    recivedAmountController.clear();
    referenceNoContr.clear();
    descriptionContr.clear();
    customerTxtCont.clear();
    phoneNumberController.clear();

    // Resetting any additional Rx variables or values
    subTotalP.value = 0.0;
    totalDiscount.value = 0.0;
    totalTaxes.value = 0.0;
    totalPrice.value = 0.0;
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
  void addItem({required ItemModel item}) {
    itemList.add(item);
    _calculateGrandTotal();
  }

  List<File?> fileList = [null, null];
  List<String?> fileNames = [null, null];
  RxString documentName = ''.obs;
  RxString imgPath = ''.obs;

  RxBool isChecked = false.obs;

  void _calculateGrandTotal() {
    itemSettingsController.fetchSettingData();
    final priceDecimalCount =
        itemSettingsController.priceNotifier.value.toInt();
    double totalDiscount = 0.0;
    double totalTax = 0.0;
    double totalQty = 0.0;
    double subTotals = 0.0;

    for (int i = 0; i < itemList.length; i++) {
      ItemModel obj = itemList[i];
      double itemDiscount = double.parse(
          obj.discount == '' || obj.discount == null
              ? "0.0"
              : obj.discount.toString());
      double itemTax = double.parse(obj.taxAmt == '' || obj.taxAmt == null
          ? "0.0"
          : obj.taxAmt.toString());
      double itemQty = double.parse(obj.quantity == '' || obj.quantity == null
          ? "1.0"
          : obj.quantity.toString());
      double subTotal = double.parse(obj.total ?? "0.0");
      totalDiscount = totalDiscount + itemDiscount;
      totalTax = totalTax + itemTax;
      totalQty = totalQty + itemQty;
      subTotals = subTotals + subTotal;
    }

    grandSubTotal.value = subTotals;
    grandTax.value = totalTax;
    grandQty.value = totalQty;
    grandDiscount.value = totalDiscount;
    totalAmountContr.text = subTotals.toStringAsFixed(priceDecimalCount);
  }

  // void calculateTotalAmount({
  //   double quantity = 1.0,
  //   double price = 0.0,
  //   double discountPercentage = 0.0,
  //   double taxPercentage = 0.0,
  // }) {
  //   printInfo(info: "discountPrecentage==$discountPercentage");
  //
  //   double baseAmount = quantity * price;
  //   subTotalP.value = baseAmount;
  //
  //   double discountAmount = (discountPercentage / 100) * baseAmount;
  //   totalDiscount.value = discountAmount;
  //
  //   double taxableAmount = baseAmount - discountAmount;
  //   double taxAmount = (taxPercentage / 100) * taxableAmount;
  //   totalTaxes.value = taxAmount;
  //
  //   double totalAmount = taxableAmount + taxAmount;
  //
  //   totalPrice.value = totalAmount;
  //   totalAmountContr.text = totalAmount.toString();
  // }

  // void calculateTotalAmount({
  //   double quantity = 1.0,
  //   double price = 0.0,
  //   double discountPercentage = 0.0,
  //   double taxPercentage = 0.0,
  // }) {
  //   itemSettingsController.fetchSettingData();
  //   final priceDecimalCount =
  //       itemSettingsController.priceNotifier.value.toInt();
  //   bool taxtype = isTaxOrNo.value == 'Without Tax' ? true : false;
  //   print("taxtype******** : $taxtype");
  //
  //   printInfo(info: "discountPrecentage==$discountPercentage");
  //
  //   double baseAmount = quantity * price;
  //   double discountAmount = (discountPercentage / 100) * baseAmount;
  //   totalDiscount.value = discountAmount;
  //
  //   double taxableAmount = baseAmount - discountAmount;
  //
  //   // ✅ Update subTotalP before tax calculation
  //   subTotalP.value = taxtype
  //       ? baseAmount
  //       : baseAmount /
  //           (1 + (double.parse(selectedTax.value.rate ?? "0") / 100));
  //
  //   double taxAmount = taxtype
  //       ? (taxPercentage / 100) * taxableAmount
  //       : (taxPercentage / 100) * subTotalP.value;
  //   totalTaxes.value = taxAmount;
  //
  //   double totalAmount = taxtype ? (taxableAmount + taxAmount) : baseAmount;
  //
  //   totalPrice.value = totalAmount;
  //   totalAmountContr.text = totalAmount.toStringAsFixed(priceDecimalCount);
  //
  //   // Debugging prints
  //   print("baseAmount ${baseAmount}");
  //   print("discountAmount ${discountAmount}");
  //   print("totalDiscount.value ${totalDiscount.value}");
  //   print("taxableAmount ${taxableAmount}");
  //   print("taxAmount ${taxAmount}");
  //   print("totalTaxes.value ${totalTaxes.value}");
  //   print("totalAmount ${totalAmount}");
  //   print("totalPrice.value  ${totalPrice.value}");
  //   print("totalAmountContr.text ${totalAmountContr.text}");
  //   print("subTotalP.value  ${subTotalP.value}");
  //   print("_controller.selectedTax.value.rate  ${selectedTax.value.rate}");
  // }

  final TextEditingController discountAmountContr = TextEditingController();

  void calculateTotalAmount({
    double quantity = 1.0,
    double price = 0.0,
    double discountPercentage = 0.0,
    double taxPercentage = 0.0,
  }) {
    itemSettingsController.fetchSettingData();
    final priceDecimalCount =
        itemSettingsController.priceNotifier.value.toInt();
    bool taxtype = isTaxOrNo.value == 'Without Tax' ? true : false;

    double baseAmount = quantity * price;
    double discountAmount = (discountPercentage / 100) * baseAmount;
    totalDiscount.value = discountAmount; // Update discount amount

    double taxableAmount = baseAmount - discountAmount;

    subTotalP.value = taxtype
        ? baseAmount
        : baseAmount /
            (1 + (double.parse(selectedTax.value.rate ?? "0") / 100));

    double taxAmount = taxtype
        ? (taxPercentage / 100) * taxableAmount
        : (taxPercentage / 100) * subTotalP.value;
    totalTaxes.value = taxAmount;

    double totalAmount = taxtype ? (taxableAmount + taxAmount) : baseAmount;

    totalPrice.value = totalAmount;
    totalAmountContr.text = totalAmount.toStringAsFixed(priceDecimalCount);

    // Debugging prints
    print("baseAmount $baseAmount");
    print("discountAmount $discountAmount");
    print("totalDiscount.value ${totalDiscount.value}");
    print("taxableAmount $taxableAmount");
    print("taxAmount $taxAmount");
    print("totalTaxes.value ${totalTaxes.value}");
    print("totalAmount $totalAmount");
    print("totalPrice.value ${totalPrice.value}");
    print("totalAmountContr.text ${totalAmountContr.text}");
    print("subTotalP.value ${subTotalP.value}");
    print("_controller.selectedTax.value.rate ${selectedTax.value.rate}");
  }

  void fetchUnitList() async {
    setLoadingValue(true);

    var response = await _apiServices.getRequest(
        endurl: EndUrl.unitListUrl,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<UnitModel> units = List<UnitModel>.from(
            jsonResponse.map((x) => UnitModel.fromJson(x)));
        if (units.length.toInt() != 0) {
          unitModel.value = units[0];
          setLoadingValue(false);
        }
        unitList.assignAll(units);

        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void fetchInvoicNo() async {
    var response = await _apiServices.getRequest(
        endurl: EndUrl.getLatestInvoice,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        InvoiceNoModel ob = InvoiceNoModel(
            id: response.data['data']['_id'],
            invoiceNo: response.data['data']['invoiceNo']);
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

  void addUnit() async {
    setLoadingValue(true);
    var data = {
      "name": unitNameController.text,
      "shortName": unitShortNameContr.text
    };
    try {
      var response = await _apiServices.postJsonData(
          endUrl: EndUrl.unitListUrl,
          data: data,
          authToken: await SharedPreLocalStorage.getToken());
      if (response != null) {
        printInfo(info: "response to save invoice==$response");
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          fetchUnitList();
          addUnitEnable.value = true;
          SnackBars.showSuccessSnackBar(text: "Successfully saved unit");

          setLoadingValue(false);
        }
        setLoadingValue(false);
      }
      setLoadingValue(false);
    } catch (e) {
      setLoadingValue(false);
      SnackBars.showErrorSnackBar(text: "Error $e");
    }
  }

  void clearItemController() {
    isEditingItem.value = false;
    itemNameContr.text = '';
    quantityContr.text = '';
    priceContr.text = '';
    discountContr.text = '';
    totalAmountContr.text = '';
    subTotalP.value = 0.0;
    totalDiscount.value = 0.0;
    selectedTax.value;
    selectedTax.value = TaxModel(taxType: "None", rate: '0.0');
    totalTaxes.value = 0.0;
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
      'pdf',
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
    if (customerTxtCont.text.isEmpty &&
        selectedSaleType.value.toString() != "Cash") {
      SnackBars.showErrorSnackBar(text: "Please enter customer");
      return "Please enter customer";
    } else if (itemList.length.toInt() == 0) {
      SnackBars.showErrorSnackBar(text: "Please add item");
      return "Please add item";
    } else if (invoiceNo.value.invoiceNo == null) {
      SnackBars.showErrorSnackBar(text: "Empty invoice number");
      return "Empty invoice number";
    }

    // else if (descriptionContr.text.isEmpty) {
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

  RxString selectedPayableMethod = 'Cash'.obs;

  addSale() async {
    setLoadingValue(true);
    TransactionDetailController().isEditingFromSalesInvoice.value = false;

    List<Map<String, dynamic>> items = [];
    List<Map<String, dynamic>> paymentType = [
      {
        "method": selectedPayableMethod.value,
        "amount": grandSubTotal.value.toStringAsFixed(2).toString(),
        "bankName": selectedPaymentType.value.id,
        "referenceNo": referenceNoContr.text
      }
    ];
    for (int i = 0; i < itemList.length; i++) {
      ItemModel item = itemList[i];
      Map<String, dynamic> object = {
        "name": item.itemName,
        "quantity": item.quantity,
        "unit": item.unit,
        "price": item.price,
        "taxAmount": item.taxAmt,
        "discountPercent": item.discountP ?? "",
        // "taxPercent": item.taxPercent,
        "taxPercent": item.taxPercent ?? "",
        "finalAmount": item.total
      };
      items.add(object);
    }

    dio.FormData formData = dio.FormData.fromMap({
      'godown': itemLocationCont.text,
      'invoiceNo': invoiceNo.value.invoiceNo.toString(),
      'invoiceType': selectedSaleType.value.toString(),
      'invoiceDate': selectedSaleDate.value.toString(),
      'partyName': customerTxtCont.text,
      'billingName': customerTxtCont.text,
      'stateOfSupply': selectedState.value.id == null
          ? ''
          : selectedState.value.id.toString(),
      'phoneNo': phoneNumberController.text,
      'billingAddress': '',
      'description': descriptionContr.text,
      // 'paymentMethod': selectedPaymentType.value.toString(),
      // 'bankName': '',
      // 'items':[{ "name": "item1", "quantity": '2', "unit": "KILOGRAM", "price": "120", "discountPercent": "2", "taxPercent": "66f7e57fdcfcf7f3a6fc5066" ,"finalAmount":"245.76"}].toString(),
      // 'referenceNo': referenceNoContr.text,
      'roundOff': '00',
      'totalAmount': grandSubTotal.value.toStringAsFixed(2).toString(),
      'receivedAmount': double.parse(recivedAmountController.text == ""
              ? "0"
              : recivedAmountController.text)
          .toStringAsFixed(2)
          .toString(),
      // 'balanceAmount': grandSubTotal.value.toStringAsFixed(2).toString(),
      'balanceAmount': selectedSaleType.value.toString() == "Cash"
          ? 0.00
          : (grandSubTotal.value -
                  double.parse(recivedAmountController.text.isEmpty
                      ? "0"
                      : recivedAmountController.text))
              .toStringAsFixed(2),

      'source': 'Direct',
      'grossTotal': grandSubTotal.value.toStringAsFixed(2).toString(),
    });
    formData.fields.add(MapEntry('items', jsonEncode(items)));
    formData.fields.add(MapEntry('paymentMethod', jsonEncode(paymentType)));

    printInfo(info: "item ==${jsonEncode(items)}");

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
        endUrl: EndUrl.invoiceUrl,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      printInfo(info: "response to save invoice==$response");
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var homec = Get.find<HomeController>();
        fetchInvoicNo();
        fetchCustomerParty();
        Get.back();
        setLoadingValue(true);
        File pdfFile = await PdfService().generatePdf(
          phone: '',
          email: '',
          invoiceNo: invoiceNo.value.invoiceNo.toString(),
          date: selectedSaleDate.value.toString(),
          billTo: customerTxtCont.text,
          invoiceAmountInWords:
              grandSubTotal.value.toStringAsFixed(2).toString(),
          totalAmount: grandSubTotal.value.toStringAsFixed(2).toString(),
          receivedAmount: double.parse(recivedAmountController.text == ""
                  ? "0"
                  : recivedAmountController.text)
              .toStringAsFixed(2)
              .toString(),
          balanceAmount: grandSubTotal.value.toStringAsFixed(2).toString(),
          bankName: 'State Bank Of India, Edappal',
          accountNo: '38729908140',
          ifscCode: 'SBIN0010111',
          accountHolderName: 'Gokul',
        );
        // print("****8${response.data['data'][0]['_id']}");
        String justid = response.data['data'][0]['_id'];
        setLoadingValue(false);
        // showInvoicePdfDialog(filePath: pdfFile.path);
        Get.to(() => PdfPreviewPage(
              object: pdfFile.path,
              id: justid,
              type: "Sale",
            ));

        clearController();
        clearItemController();
        SnackBars.showSuccessSnackBar(text: "Successfully saved invoice");
        homec.getAllInvoice();
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    imgPath.value = "";
    documentName.value = "";
    setLoadingValue(false);
    saleController.getSalesInvoice();
  }

  updateSale() async {
    setLoadingValue(true);

    List<Map<String, dynamic>> items = [];
    List<Map<String, dynamic>> paymentType = [
      {
        "method": selectedPayableMethod.value,
        "amount": grandSubTotal.value.toStringAsFixed(2).toString(),
        "bankName": selectedPaymentType.value.id,
        "referenceNo": referenceNoContr.text
      }
    ];
    // List<Map<String, dynamic>> items = [];
    for (int i = 0; i < itemList.length; i++) {
      ItemModel item = itemList[i];
      Map<String, dynamic> object = {
        "name": item.itemName,
        "quantity": item.quantity,
        "unit": item.unit,
        "price": item.price,
        "taxAmount": item.taxAmt,
        "discountPercent": item.discountP ?? "",
        // "taxPercent": item.taxPercent,
        "taxPercent": item.taxPercent ?? "",
        "finalAmount": item.total
      };
      items.add(object);
    }

    dio.FormData formData = dio.FormData.fromMap({
      'godown': itemLocationCont.text,
      'invoiceNo': invoiceNo.value.invoiceNo.toString(),
      'invoiceType': selectedSaleType.value.toString(),
      'invoiceDate': selectedSaleDate.value.toString(),
      'partyName': customerTxtCont.text,
      'billingName': customerTxtCont.text,
      'stateOfSupply': selectedState.value.id == null
          ? ''
          : selectedState.value.id.toString(),
      'phoneNo': phoneNumberController.text,
      'billingAddress': '',
      'description': descriptionContr.text,
      // 'paymentMethod': selectedPaymentType.value.toString(),
      // 'bankName': '',
      // 'items':[{ "name": "item1", "quantity": '2', "unit": "KILOGRAM", "price": "120", "discountPercent": "2", "taxPercent": "66f7e57fdcfcf7f3a6fc5066" ,"finalAmount":"245.76"}].toString(),
      // 'referenceNo': referenceNoContr.text,
      'roundOff': '00',
      'totalAmount': grandSubTotal.value.toStringAsFixed(2).toString(),
      'receivedAmount': double.parse(recivedAmountController.text == ''
              ? '0'
              : recivedAmountController.text)
          .toStringAsFixed(2)
          .toString(),
      // 'balanceAmount': grandSubTotal.value.toStringAsFixed(2).toString(),
      'balanceAmount': selectedSaleType.value.toString() == "Cash"
          ? 0.00
          : (grandSubTotal.value -
                  double.parse(recivedAmountController.text.isEmpty
                      ? "0"
                      : recivedAmountController.text))
              .toStringAsFixed(2),

      'source': 'Direct',
      'grossTotal': grandSubTotal.value.toStringAsFixed(2).toString(),
    });
    formData.fields.add(MapEntry('items', jsonEncode(items)));
    formData.fields.add(MapEntry('paymentMethod', jsonEncode(paymentType)));
    printInfo(info: "item ==${jsonEncode(items)}");

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
        endUrl: EndUrl.invoiceUrl + saleId.value,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      printInfo(info: "response to save invoice==$response");
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var homec = Get.find<HomeController>();
        var controller = SaleInvoiceOrReportController();
        controller.getSalesInvoice();
        fetchInvoicNo();
        // Get.back();
        isEditingFromSalesInvoice.value
            ? Get.off(() => SaleInvoistListScreen())
            : Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully saved invoice");
        homec.getAllInvoice();
        var _saleinvoicecontroller = SaleInvoiceOrReportController();
        _saleinvoicecontroller.getSalesInvoice();

        setLoadingValue(false);
      }

      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  RxBool yourEditingSale = false.obs;

  void getSaleDetailById({required String id}) async {
    try {
      saleId.value = id;

      setLoadingValue(true);

      var response = await _apiServices.getRequest(
          endurl: EndUrl.invoiceUrl + id,
          authToken: await SharedPreLocalStorage.getToken());

      if (response != null) {
        setLoadingValue(false);
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          var jsonResponse = response.data['data'];
          // ;
          SaleDetailModelEdit model =
              SaleDetailModelEdit.fromJson(jsonResponse);
          // log("Sale Model ==${model.toJson()}");
          itemLocationCont.text = model.godown?.id! ?? "NA";
          selectedLocation.value = model.godown?.id! ?? "NA";
          invoiceNo.value.invoiceNo = model.invoiceNo;
          customerTxtCont.text = model.billingName.toString();
          selectedState.value.id = model.stateOfSupply;
          phoneNumberController.text = model.phoneNo.toString();
          descriptionContr.text = model.description.toString();
          recivedAmountController.text = model.receivedAmount.toString();
          isChecked.value = true;
          isPriceEntered.value = true;
          List<ItemModel> itemListT = [];
          if (model.items != null) {
            for (int i = 0; i < model.items!.length; i++) {
              var obj = model.items![i];
              ItemModel cIModel = ItemModel(
                  price: obj.price.toString(),
                  discountP: obj.discountPercent != null
                      ? obj.discountPercent.toString()
                      : "",
                  itemName:
                      obj.itemId != null || obj.itemId.toString() != "null"
                          ? obj.itemId!.itemName
                          : "",
                  quantity: obj.quantity.toString(),
                  taxAmt: obj.taxAmount != null ||
                          obj.taxAmount.toString() != "null"
                      ? obj.taxAmount.toString()
                      : "",
                  taxPercent: obj.taxPercent != null ||
                          obj.taxPercent.toString() != "null"
                      ? obj.taxPercent!.id
                      : "",
                  taxRate: obj.taxPercent?.rate != null ||
                          obj.taxPercent?.rate.toString() != "null"
                      ? obj.taxPercent?.rate
                      : "",
                  total: obj.finalAmount.toString(),
                  subtotalP: obj.price.toString(),
                  unit: obj.unit != null || obj.unit.toString() != "null"
                      ? obj.unit!.name
                      : "");
              itemListT.add(cIModel);
            }
          }
          itemList.assignAll(itemListT);
          calculateTotalAmount();
          _calculateGrandTotal();
          // List<Item> items = model.items!.toList();
          Get.to(() => const AddSaleInvoiceScreen());
        }
      }

      setLoadingValue(false);
    } catch (e) {
      setLoadingValue(false);
      log("Error when edit  sale ==${e}");
    }
  }

  void filterItems({String? name}) async {
    List<String> list = await SharedPreLocalStorage.getItemList();
    if (name == null || name.isEmpty) {
      // filteredCPlist.assignAll(customerPartyNmList);
      itemListString.assignAll([]);
      return;
    }

    var filteredList = list.where((customer) {
      return customer.toLowerCase().startsWith(name.toLowerCase());
    }).toList();
    // log("Filterd item list ==${filteredList}");

    itemListString.assignAll(filteredList);
    // customerPartyNmList.value = filteredList;
  }

  void deleteSaleById({required String id}) async {
    setLoadingValue(true);

    var response = await _apiServices.deleteRequest(
        endurl: EndUrl.invoiceUrl + id,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        final controller = Get.find<HomeController>();

        controller.getAllInvoice();
        SnackBars.showSuccessSnackBar(text: "Deleted invoice");
        Get.back();
      }
    }

    setLoadingValue(false);
  }

  void deletePaymentIn({required String id}) async {
    DateController dateController = Get.put(DateController());
    setLoadingValue(true);

    var response = await _apiServices.deleteRequest(
        endurl: EndUrl.deletePaymentIn + id,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        final controller = Get.put(PaymentInController());
        controller.getAllTransaction(
            date: DateFilterModel(
                startDate: dateController.startDateIs.value,
                endDate: dateController.endDateIs.value));
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Deleted PaymentIn");
      }
    }

    setLoadingValue(false);
  }

  //bank details

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
              Get.to(() => AddBankScreen());
            });
        SnackBars.showSuccessSnackBar(text: "Saved Bank Detail");
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }
}
