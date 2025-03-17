import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/add_stock_transfer.dart';
import 'package:newthijar/model/godown_type_model.dart';
import 'package:newthijar/model/item_bar_list_model.dart';
import 'package:newthijar/model/manage_godown_model.dart';
import 'package:newthijar/model/stock_transfer_detail_model.dart';
import 'package:newthijar/model/stock_transfer_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/godown_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/easy_loading.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class AddGodownController extends GetxController {
  final TextEditingController godownTypeController = TextEditingController();
  final TextEditingController godownNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController taxRegNumController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController godownAddressController = TextEditingController();
  RxList<Datas> allGodowns = <Datas>[].obs;
  RxList<GodownTypeModel> allGodownsTypes = <GodownTypeModel>[].obs;
  String? godownType;
  final GodownService _service = GodownService();
  Rxn<ItemBarList> selectedItem = Rxn();
  final ApiServices _apiServices = ApiServices();
  RxList<ItemBarList> itemList = <ItemBarList>[].obs;
  RxList<ItemBarList> filterdItemList = <ItemBarList>[].obs;

  RxList<AddStockItem> stockItemList = RxList.empty();
  RxList<StockTransferModel> _stockDataList = RxList.empty();
  RxList<StockTransferModel> filterStockDataList = RxList.empty();
  Rxn<StockTransferDetails> stockTransferDetails = Rxn();

  Future fetchStockTransferList() async {
    try {
      _stockDataList.clear();
      filterStockDataList.clear();
      setLoadingValue(true);
      loading(show: true);

      var response = await _apiServices.getRequest(
        endurl: EndUrl.stockTransfer,
        authToken: await SharedPreLocalStorage.getToken(),
      );
      if (response != null) {
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          final model = StockTransferData.fromMap(response.data);
          _stockDataList.value = model.data ?? [];
          filterStockDataList.assignAll(_stockDataList);
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong..",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setLoadingValue(false);
      loading(show: false);
    }
  }

  Future fetchStockTransferDetails(String id) async {
    try {
      loading(show: true);

      var response = await _apiServices.getRequest(
        endurl: EndUrl.stockTransferDetails + id,
        authToken: await SharedPreLocalStorage.getToken(),
      );
      if (response != null) {
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          final model = StockTransferDetails.fromMap(response.data);

          stockTransferDetails.value = model;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong..",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      loading(show: false);
    }
  }

  void searchStockTransfer(String value) {
    filterStockDataList.assignAll(_stockDataList.where((stockTransfer) {
      return ((stockTransfer.toGodownDetails!.first.name ?? "")
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          (stockTransfer.fromGodownDetails!.first.name ?? "")
              .toLowerCase()
              .contains(value.toLowerCase()));
    }).toList());
  }

  /// Submit Godown details
  void submitGodownDetails() async {
    final godown = Datas(
      type: godownType,
      name: godownNameController.text.trim(),
      phoneNo: phoneNumberController.text.trim(),
      email: emailIdController.text.trim(),
      gstIn: taxRegNumController.text.trim(),
      pinCode: pinCodeController.text.trim(),
      address: godownAddressController.text.trim(),
      location: "", // Set appropriate value if needed
    );

    if (godown.name!.isEmpty ||
        godown.phoneNo!.isEmpty ||
        godown.email!.isEmpty ||
        godown.type!.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final isSuccess = await _service.addGodown(godown);
    await fetchAllGodowns();

    if (isSuccess) {
      Get.back();
      Get.snackbar(
        "Success",
        "Godown added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
    } else {
      Get.snackbar(
        "Error",
        "Failed to add Godown. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchItemList() async {
    selectedItem.value = null;
    setLoadingValue(true);

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

  Future<void> addStockTransfer({
    required String toGodown,
    required String fromGodown,
    required DateTime transferDate,
  }) async {
    try {
      loading(show: true);
      final AddStockTransfer addStockItem = AddStockTransfer(
        toGodown: toGodown,
        fromGodown: fromGodown,
        items: stockItemList,
        transferDate: transferDate,
      );

      var response = await _apiServices.postJsonData(
        endUrl: EndUrl.stockTransfer,
        authToken: await SharedPreLocalStorage.getToken(),
        data: addStockItem.toMap(),
      );
      if (response != null) {
        print(response.data);
        Get.back();
        if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
          Get.snackbar(
            "Success",
            response.data['message'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong..",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      loading(show: false);
    }
  }

  /// Fetch all Godowns
  fetchAllGodowns() async {
    try {
      setLoadingValue(true);
      allGodowns.value = await _service.fetchGodowns();
      for (int i = 0; i < allGodowns.length; i++) {
        print(allGodowns[i].name);
      }

      log("successfully fetched");
      setLoadingValue(false);
    } catch (e) {
      log("error in godown controller : $e");
    }
  }

  fetchAllGodownsType() async {
    try {
      allGodownsTypes.value = await _service.fetchGodownsTypes();
      log("successfully fetched all godown types");
    } catch (e) {
      log("error in godown types controller : $e");
    }
  }

  /// Update Godown details
  void updateGodownDetails(String id) async {
    final godown = Datas(
      type: godownTypeController.text.trim(),
      name: godownNameController.text.trim(),
      phoneNo: phoneNumberController.text.trim(),
      email: emailIdController.text.trim(),
      gstIn: taxRegNumController.text.trim(),
      pinCode: pinCodeController.text.trim(),
      address: godownAddressController.text.trim(),
      location: "", // Set appropriate value if needed
    );

    if (godown.name!.isEmpty ||
        godown.phoneNo!.isEmpty ||
        godown.email!.isEmpty ||
        godown.type!.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final isSuccess = await _service.updateGodown(id, godown);

    if (isSuccess) {
      Get.back();
      Get.snackbar(
        "Success",
        "Godown updated successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
    } else {
      Get.snackbar(
        "Error",
        "Failed to update Godown. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Delete Godown
  void deleteGodown(String id) async {
    final isSuccess = await _service.deleteGodown(id);
    await fetchAllGodowns();
    if (isSuccess) {
      Get.snackbar(
        "Success",
        "Godown deleted successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to delete Godown. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Clear form fields
  void clearFields() {
    godownType = "Select Godown Type";
    godownTypeController.clear();
    godownNameController.clear();
    phoneNumberController.clear();
    emailIdController.clear();
    godownAddressController.clear();
    pinCodeController.clear();
    taxRegNumController.clear();
  }
}
