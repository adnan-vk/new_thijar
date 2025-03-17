import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/category_model.dart';
import 'package:newthijar/model/conversion_reference_model.dart';
import 'package:newthijar/model/item_bar_list_model.dart';
import 'package:newthijar/model/item_model_one_object.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/godown_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';
import '../../../model/manage_godown_model.dart';
import '../../../model/tax_model.dart';
import '../../../model/unit_model.dart';

class ItemScreenController extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final cateController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  final itemCodeController = TextEditingController();
  final itemHsnCodeController = TextEditingController();
  final salePriceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final discOnSaleController = TextEditingController();
  final mrpController = TextEditingController();
  //
  final FocusNode focusNode = FocusNode();
  //stock
  final openingStockCon = TextEditingController();
  final stockDateCon = TextEditingController();
  final stockPriceUnitCont = TextEditingController();
  final stockMinQtyCont = TextEditingController();
  final itemLocationCont = TextEditingController();
  //
  final TextEditingController searchController = TextEditingController();
  RxList categoryList = <CategoryModel>[].obs;
  TextEditingController categoryTextController = TextEditingController();
  var selectedCate = CategoryModel().obs;
  var selectedUnitModel = UnitModel(name: "Select Unit").obs;
  RxList<UnitModel> unitList = <UnitModel>[].obs;
  RxList<UnitModel> primaryUnitList = <UnitModel>[].obs;
  RxList<UnitModel> secondaryUnit = <UnitModel>[].obs;
  RxList<ItemBarList> itemList = <ItemBarList>[].obs;
  RxList<ItemBarList> filterdItemList = <ItemBarList>[].obs;
  Rxn<ItemBarList> selectedItem = Rxn();
  RxBool isFetchingMore = false.obs; // ✅ Added missing variable
  RxBool isLoading = false.obs; // ✅ Ensuring isLoading is defined
  Rx<TaxModel> selectedTaxValue =
      TaxModel(rate: "Select Tax", id: "id", taxType: "Type").obs;

  var selectedPrimaryUnit = UnitModel(name: "Select Unit").obs;
  var selectedSecondaryUnit = UnitModel().obs;
  bool isProductSelected = false;

  RxBool salesPriceIncludingTax = false.obs;
  RxBool purchasePriceIncludingTax = false.obs;
  RxString discountType = "Percentage".obs;
  bool validatecategoryFiled() {
    if (categoryTextController.text.isEmpty) {
      SnackBars.showErrorSnackBar(text: "Please Enter Category Name");
      return false;
    } else {
      return true;
    }
  }

  ///  Adjust stock
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  String stockAction = 'Add Stock';

  void dispose() {
    dateController.dispose();
    quantityController.dispose();
    priceController.dispose();
    detailsController.dispose();
  }

  // Validate form fields
  String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the quantity';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the price';
    }
    return null;
  }

  void submitForm(BuildContext context) {
    if (validateDate(dateController.text) == null &&
        validateQuantity(quantityController.text) == null &&
        validatePrice(priceController.text) == null) {
      String message = stockAction == 'Add Stock'
          ? 'Stock added successfully'
          : 'Stock reduced successfully';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  // Handle date selection
  void selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  ///
  var conversionRateController = TextEditingController();
  RxString conversionRateValue = "".obs;

  void addCategory() async {
    setLoadingValue(true);
    var response = await _apiServices.postJsonData(
        endUrl: EndUrl.getCategory + categoryTextController.text,
        data: {},
        authToken: await SharedPreLocalStorage.getToken());
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchCategories();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Added Category");
      }
    }
    setLoadingValue(false);
  }

  void fetchCategories() async {
    setLoadingValue(true);

    String? token = await SharedPreLocalStorage.getToken();
    if (token.toString() == null.toString()) {
      log("Token not found. User may need to log in.");
      SnackBars.showErrorSnackBar(text: "Please log in again.");
      setLoadingValue(false);
      return;
    }

    var response = await _apiServices.getRequest(
      endurl: EndUrl.getCategory,
      authToken: token,
    );

    if (response != null && response.statusCode == 200) {
      var jsonResponse = response.data['data'];
      List<CategoryModel> list = List<CategoryModel>.from(
        jsonResponse.map((x) => CategoryModel.fromJson(x)),
      );

      categoryList.assignAll(list);
    } else {
      log("Error fetching categories: ${response?.statusMessage}");
      SnackBars.showErrorSnackBar(
        text: "Failed to fetch categories. Please try again.",
      );
    }

    setLoadingValue(false);
  }

  void clearControllers() {
    selectedTaxValue.value =
        TaxModel(rate: "Select Tax", id: "id", taxType: "Type");
    selectedPrimaryUnit = UnitModel(name: "Select Unit").obs;
    selectedSecondaryUnit = UnitModel().obs;
    conversionRateValue = "".obs;

    cateController.clear();
    itemNameController.clear();
    mrpController.clear();
    itemCodeController.clear();
    itemHsnCodeController.clear();
    salePriceController.clear();
    discOnSaleController.clear();
    searchController.clear();
    purchasePriceController.clear();
    openingStockCon.clear();
    stockDateCon.clear();
    stockPriceUnitCont.clear();
    stockMinQtyCont.clear();
    itemLocationCont.clear();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllGodowns();
    fetchItemList();
    fetchUnitList();
    fetchTax();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        filterdItemList.assignAll(itemList);
      } else {
        filterdItemList.assignAll([]);
      }
    });
  }

  /// **Extract all conversionReferences from unitList**
  List<ConversionReferenceModel> allConversionReferences = [];
  Future<void> fetchUnitList() async {
    setLoadingValue(true);

    var response = await _apiServices.getRequest(
        endurl: EndUrl.unitListUrl,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<UnitModel> units = List<UnitModel>.from(
          jsonResponse.map(
            (x) => UnitModel.fromJson(x),
          ),
        );

        setLoadingValue(false);
        unitList.assignAll(units);
        primaryUnitList.assignAll(units);

        for (var unit in unitList) {
          if (unit.conversionReferences != null) {
            allConversionReferences.addAll(unit.conversionReferences!);
          }
        }

        /// **Print all conversion references**
        print(
            "All Conversion References:* ${allConversionReferences.map((e) => e.toJson()).toList()} ***");
        print("All bi");
      }
    }

    setLoadingValue(false);
  }

  void addUnit({required String name, required String shortName}) async {
    setLoadingValue(true);
    var data = {"name": name, "shortName": shortName};
    try {
      var response = await _apiServices.postJsonData(
          endUrl: EndUrl.unitListUrl,
          data: data,
          authToken: await SharedPreLocalStorage.getToken());

      if (response != null) {
        printInfo(info: "response to save invoice==$response");
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          fetchUnitList();

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

  RxString newConversionId = ''.obs;

  void addNewConversion(
      {required String baseUnit,
      required String secondaryUnit,
      required String conversionRate}) async {
    setLoadingValue(true);

    var data = {
      "baseUnit": baseUnit,
      "secondaryUnit": secondaryUnit,
      "rate": conversionRate
    };

    try {
      var response = await _apiServices.postJsonData(
        endUrl: EndUrl.newConversion,
        data: data,
        authToken: await SharedPreLocalStorage.getToken(),
      );

      if (response != null) {
        printInfo(info: "Raw Response: $response");

        var jsonResponse = response.data;

        if (jsonResponse["status"] == "Success") {
          String message =
              jsonResponse["message"] ?? "Successfully created new conversion";

          // ✅ Save the new conversion ID inside the controller
          newConversionId.value =
              (jsonResponse["data"] != null && jsonResponse["data"].isNotEmpty)
                  ? jsonResponse["data"][0]["_id"]
                  : '';

          SnackBars.showSuccessSnackBar(text: message);

          printInfo(info: "New conversion ID saved: ${newConversionId.value}");
        } else {
          SnackBars.showErrorSnackBar(
              text: jsonResponse["message"] ?? "Failed to create conversion");
        }
      }
    } catch (e) {
      SnackBars.showErrorSnackBar(text: "Error: $e");
    } finally {
      setLoadingValue(false);
    }
  }

  void resetAllFields() {
    selectedPrimaryUnit.value = UnitModel();
    selectedSecondaryUnit.value = UnitModel();
    secondaryUnit.clear();
    conversionRateController.clear();
    newConversionId.value = "";

    // Refresh UI
    selectedPrimaryUnit.refresh();
    selectedSecondaryUnit.refresh();
  }

  Future<void> fetchItemList({bool isLoadMore = false}) async {
    selectedItem.value = null;
    // setLoadingValue(true);

    var response = await _apiServices.getRequest(
        endurl: EndUrl.addItem,
        authToken: await SharedPreLocalStorage.getToken());
    //  printInfo(info: "response status code ==${response!.data}");
    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];

        List<ItemBarList> units = List<ItemBarList>.from(
            jsonResponse.map((x) => ItemBarList.fromJson(x)));

        setLoadingValue(false);
        itemList.assignAll(units);
        filterdItemList.assignAll(itemList);
        // print("Item length==${itemList.length}");
        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  // void fetchItemList({bool isLoadMore = false}) async {
  //   if (!isLoadMore) {
  //     setLoadingValue(true);
  //   }

  //   var response = await _apiServices.getRequest(
  //       endurl: EndUrl.addItem,
  //       authToken: await SharedPreLocalStorage.getToken());

  //   if (response != null) {
  //     if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
  //       var jsonResponse = response.data['data'];

  //       List<ItemBarList> list = List<ItemBarList>.from(
  //           jsonResponse.map((x) => ItemBarList.fromJson(x)));

  //       if (isLoadMore) {
  //         itemList.addAll(list);
  //       } else {
  //         itemList.assignAll(list);
  //       }

  //       setLoadingValue(false);
  //     }
  //     setLoadingValue(false);
  //   }
  //   setLoadingValue(false);
  // }

  RxList<TaxModel> taxList = <TaxModel>[].obs;
  Future<void> fetchTax() async {
    log("Fetching tax");
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

  void addItem() async {
    final itemName = itemNameController.text.trim();

    // Check if the item already exists in the list
    bool itemExists = itemList
        .any((item) => item.itemName!.toLowerCase() == itemName.toLowerCase());

    if (itemExists) {
      SnackBars.showErrorSnackBar(text: "Item already exists in the list.");
      return;
    }

    setLoadingValue(true);

    List<String> cateLIst = [cateController.text];

    dio.FormData formData = dio.FormData.fromMap({
      'itemName': itemName,
      'itemHsn': itemHsnCodeController.text,
      'itemCode': itemCodeController.text,
      'unit': selectedPrimaryUnit.value.id,
      'salePrice': salePriceController.text,
      'purchasePrice': purchasePriceController.text,
      'salePriceIncludesTax': salesPriceIncludingTax.value,
      "purchasePriceIncludesTax": purchasePriceIncludingTax.value,
      "taxRate": selectedTaxValue.value.id,
      'discountType': discountType.value,
      "discountValue": discOnSaleController.text,
      'openingQuantity': openingStockCon.text,
      'stockPrice': stockPriceUnitCont.text,
      'minStockToMaintain': stockMinQtyCont.text,
      'location': itemLocationCont.text,
      'type': isProductSelected == true ? "Service" : "Product",
      'mrp': mrpController.text,
    });
    if (cateLIst.isEmpty && !cateLIst.any((element) => element.isEmpty)) {
      formData.fields.add(MapEntry('category', jsonEncode(cateLIst)));
    }

    var response = await _apiServices.postMultiPartData(
        data: formData,
        endUrl: EndUrl.addItem,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchItemList();
        clearControllers();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully saved item");
      }
    }

    setLoadingValue(false);
  }

  void addItemWithConversion() async {
    final itemName = itemNameController.text.trim();

    // Check if the item already exists in the list
    bool itemExists = itemList
        .any((item) => item.itemName!.toLowerCase() == itemName.toLowerCase());

    if (itemExists) {
      SnackBars.showErrorSnackBar(text: "Item already exists in the list.");
      return;
    }

    setLoadingValue(true);

    List<String> cateLIst = [cateController.text];

    dio.FormData formData = dio.FormData.fromMap({
      'itemName': itemName,
      'itemHsn': itemHsnCodeController.text,
      'itemCode': itemCodeController.text,
      'unitConversion': newConversionId.value,
      'salePrice': salePriceController.text,
      'purchasePrice': purchasePriceController.text,
      'salePriceIncludesTax': salesPriceIncludingTax.value,
      "purchasePriceIncludesTax": purchasePriceIncludingTax.value,
      "taxRate": selectedTaxValue.value.id,
      'discountType': discountType.value,
      "discountValue": discOnSaleController.text,
      'openingQuantity': openingStockCon.text,
      'stockPrice': stockPriceUnitCont.text,
      'minStockToMaintain': stockMinQtyCont.text,
      'location': itemLocationCont.text,
      'type': isProductSelected == true ? "Service" : "Product",
      'mrp': mrpController.text,
    });
    if (cateLIst.isEmpty && !cateLIst.any((element) => element.isEmpty)) {
      formData.fields.add(MapEntry('category', jsonEncode(cateLIst)));
    }

    var response = await _apiServices.postMultiPartData(
        data: formData,
        endUrl: EndUrl.addItem,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchItemList();
        clearControllers();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully saved item");
      }
    }

    setLoadingValue(false);
  }

  RxString itemId = ''.obs;
  RxBool youUpdating = false.obs;

  var itemObject = ItemModelOneObject().obs;

  get busiNessProfileModel => null;

  void fetchItemObjectById({required String id}) async {
    youUpdating.value = true;
    itemId.value = id;
    setLoadingValue(true);

    var response = await _apiServices.getRequest(
        endurl: EndUrl.addItem + id,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];
        log("json Response of Item===$jsonResponse");
        // printInfo(info: "sale object ===${model.items!.length}");
        // Get.to(() => AddSaleInvoiceScreen());
        ItemModelOneObject object =
            ItemModelOneObject.fromJson(jsonResponse[0]);
        itemObject.value = object;
        itemNameController.text = object.itemName.toString();
        itemCodeController.text = object.itemCode.toString();
        if (object.category != null && object.category!.isNotEmpty) {
          cateController.text = object.category![0]["name"].toString();
        }
        mrpController.text = object.mrp?.toStringAsFixed(2) ?? "0.0";
        itemHsnCodeController.text = object.itemHsn ?? "";
        salePriceController.text = object.salePrice.toString();
        purchasePriceController.text = object.purchasePrice.toString();
        discOnSaleController.text = object.discount?.value.toString() ?? "0";
        salesPriceIncludingTax.value = object.salePriceIncludesTax ?? false;
        purchasePriceIncludingTax.value =
            object.purchasePriceIncludesTax ?? false;
        selectedTaxValue.value.id = object.taxRate?.id ?? "";
        if (object.stock != null && object.stock.toString() != "null") {
          openingStockCon.text =
              (object.stock?.openingQuantity ?? 0).toString();
          stockDateCon.text = object.stock?.lastUpdated?.toString() ?? '';
          stockPriceUnitCont.text = (object.stock?.price ?? 0).toString();
          stockMinQtyCont.text =
              (object.stock?.minStockToMaintain ?? 0).toString();
          itemLocationCont.text = object.stock?.location ?? "";
          isProductSelected = object.type == "Service" ? true : false;
          selectedLocation.value = object.stock?.location ?? "No location";
          if (object.unit == null) {
            selectedPrimaryUnit.value.name =
                object.unitConversion?.baseUnit?.name ?? "Error";
            selectedPrimaryUnit.value.id =
                object.unitConversion?.baseUnit?.id ?? "Error";
            selectedPrimaryUnit.value.shortName =
                object.unitConversion?.baseUnit?.shortName ?? "Error";
            selectedSecondaryUnit.value.name =
                object.unitConversion?.secondaryUnit?.name ?? "Error";
            selectedSecondaryUnit.value.id =
                object.unitConversion?.secondaryUnit?.id ?? "Error";
            selectedSecondaryUnit.value.shortName =
                object.unitConversion?.secondaryUnit?.shortName ?? "Error";
            conversionRateValue.value =
                object.unitConversion?.conversionRate?.toString() ?? "";
          } else if (object.unitConversion == null) {
            selectedPrimaryUnit.value.name = object.unit?.name ?? "Error";
            selectedPrimaryUnit.value.id = object.unit?.id ?? "Error";
            selectedPrimaryUnit.value.shortName =
                object.unit?.shortName ?? "Error";
            selectedSecondaryUnit.value.name = null;
            selectedSecondaryUnit.value.id = null;
            selectedSecondaryUnit.value.shortName = null;
            conversionRateValue.value = "";
          }
          // if (object.unit != null) {
          //   selectedUnitModel.value = UnitModel(
          //       id: object.unit?.id,
          //       name: object.unit?.name,
          //       shortName: object.unit?.shortName);
          // }
        }
        // Get.to(() => ItemDetailsPage());

        setLoadingValue(false);
      }
    }

    setLoadingValue(false);
  }

  void clearUnitValues() {
    selectedPrimaryUnit.value.name = "Select Unit";
    selectedPrimaryUnit.value.id = null;
    selectedPrimaryUnit.value.shortName = null;
    conversionRateController.clear();
    conversionRateController.clear();

    selectedSecondaryUnit.value.name = null;
    selectedSecondaryUnit.value.id = null;
    selectedSecondaryUnit.value.shortName = null;
    selectedSecondaryUnit = UnitModel().obs;
    selectedPrimaryUnit = UnitModel(name: "Select Unit").obs;
    conversionRateValue.value = "";
    selectedLocation.value = "";
  }

  void deleteItemObjectById({required String id}) async {
    setLoadingValue(true);

    var response = await _apiServices.deleteRequest(
        endurl: EndUrl.addItem + id,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchItemList();
        // Get.to(() => const ItemPage());
        Get.back();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully Deleted Item");

        setLoadingValue(false);
      }
    }

    setLoadingValue(false);
  }

  void updateItem() async {
    setLoadingValue(true);

    List<String> cateLIst = [cateController.text];
    dio.FormData formData = dio.FormData.fromMap({
      'itemName': itemNameController.text,
      'itemHsn': itemHsnCodeController.text,
      'itemCode': itemCodeController.text,
      'unit': selectedPrimaryUnit.value.id,
      'salePrice': salePriceController.text,
      'purchasePrice': purchasePriceController.text,
      'salePriceIncludesTax': salesPriceIncludingTax.value,
      "purchasePriceIncludesTax": purchasePriceIncludingTax.value,
      "taxRate": selectedTaxValue.value.id,
      'discountType':
          discountType.value == "Fixed Amount" ? "amount" : "percentage",
      "discountValue": discOnSaleController.text,
      'openingQuantity': openingStockCon.text,
      'stockPrice': stockPriceUnitCont.text,
      'minStockToMaintain': stockMinQtyCont.text,
      'type': isProductSelected == true ? "Service" : "Product",
      'location': itemLocationCont.text,
      'mrp': mrpController.text,
      // 'taxRate': ,
    });

    if (cateLIst.isNotEmpty && !cateLIst.any((element) => element.isEmpty)) {
      formData.fields.add(MapEntry('category', jsonEncode(cateLIst)));
    }

    var response = await _apiServices.putMultiPartData(
        data: formData,
        // fileParameters: parameters,
        // files: fileList,
        endUrl: EndUrl.addItem + itemId.toString(),
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      printInfo(info: "response to save invoice==$response");
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        // var homec = Get.find<HomeController>();
        // fetchInvoicNo();

        fetchItemList();
        clearControllers();
        // Get.to(() => const ItemPage());
        Get.back();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully saved item");

        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }

  void updateItemwithtwounits() async {
    setLoadingValue(true);

    List<String> cateLIst = [cateController.text];
    dio.FormData formData = dio.FormData.fromMap({
      'itemName': itemNameController.text,
      'itemHsn': itemHsnCodeController.text,
      'itemCode': itemCodeController.text,
      // 'unit': selectedPrimaryUnit.value.id,
      'unitConversion': newConversionId.value,
      'salePrice': salePriceController.text,
      'purchasePrice': purchasePriceController.text,
      'salePriceIncludesTax': salesPriceIncludingTax.value,
      "purchasePriceIncludesTax": purchasePriceIncludingTax.value,
      "taxRate": selectedTaxValue.value.id,
      'discountType':
          discountType.value == "Fixed Amount" ? "amount" : "percentage",
      "discountValue": discOnSaleController.text,
      'openingQuantity': openingStockCon.text,
      'stockPrice': stockPriceUnitCont.text,
      'minStockToMaintain': stockMinQtyCont.text,
      'type': isProductSelected == true ? "Service" : "Product",
      'location': itemLocationCont.text,
      'mrp': mrpController.text,
      // 'taxRate': ,
    });

    if (cateLIst.isNotEmpty && !cateLIst.any((element) => element.isEmpty)) {
      formData.fields.add(MapEntry('category', jsonEncode(cateLIst)));
    }

    var response = await _apiServices.putMultiPartData(
        data: formData,
        // fileParameters: parameters,
        // files: fileList,
        endUrl: EndUrl.addItem + itemId.toString(),
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      printInfo(info: "response to save invoice==$response");
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        // var homec = Get.find<HomeController>();
        // fetchInvoicNo();

        fetchItemList();
        clearControllers();
        // Get.to(() => const ItemPage());
        Get.back();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Successfully saved item");

        setLoadingValue(false);
      }
      setLoadingValue(false);
    }
    setLoadingValue(false);
  }
  //search Item

  //fetch godown names
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
      godownNames.assignAll(
          allGodowns.map((godown) => godown.name).whereType<String>());

      // Ensure locationList updates correctly
      locationList.assignAll(godownNames);

      setLoadingValue(false);
    } catch (e) {
      log("error in godown controller : $e");
    }
  }

  void filterItems({String? name}) {
    log("CustomerParty list ==${itemList.length}");
    if (name == null || name.isEmpty) {
      // filteredCPlist.assignAll(customerPartyNmList);
      filterdItemList.assignAll(itemList);
      return;
    }

    var filteredList = itemList.where((item) {
      return item.itemName != null &&
          item.itemName!.toLowerCase().startsWith(name.toLowerCase());
    }).toList();

    filterdItemList.assignAll(filteredList);
    log("Filtered list ==${filterdItemList.length}");
    // customerPartyNmList.value = filteredList;
  }
}
