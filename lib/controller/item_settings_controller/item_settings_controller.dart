import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/item_settings_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class ItemSettingController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxBool gstTaxEnabled = false.obs;
  RxBool vatTaxEnabled = false.obs;
  RxBool enableItemCode = false.obs;
  RxBool enableItemCategory = false.obs;
  RxBool enableItemHsn = false.obs;
  RxBool enableItemDiscount = false.obs;
  RxBool enableItemMrp = false.obs;
  final ValueNotifier<num> quantityNotifier = ValueNotifier<num>(1);
  final ValueNotifier<num> priceNotifier = ValueNotifier<num>(1);

  Rx<ItemSettingModel> settingModel = ItemSettingModel().obs;

  void setTaxType({required bool isGst, required bool isWat}) {
    if (gstTaxEnabled.value == isGst && vatTaxEnabled.value == isWat) {
      if (gstTaxEnabled.value) {
        gstTaxEnabled.value = false;
      }
      if (vatTaxEnabled.value) {
        vatTaxEnabled.value = false;
      }

      updatedGstType(isGst: gstTaxEnabled.value, isVat: vatTaxEnabled.value);
    } else {
      gstTaxEnabled.value = isGst;
      vatTaxEnabled.value = isWat;
      updatedGstType(isGst: gstTaxEnabled.value, isVat: vatTaxEnabled.value);
    }
  }

  itemSettingsChange() {
    updatedItemSettings(
      enableItemCode: enableItemCode.value,
      enableItemCategory: enableItemCategory.value,
      enableItemDiscount: enableItemDiscount.value,
      enableItemHsn: enableItemHsn.value,
      enableItemMrp: enableItemMrp.value,
      priceNotifier: priceNotifier.value,
      quantityNotifier: quantityNotifier.value,
    );
  }

  updatedItemSettings({
    bool? enableItemCode,
    bool? enableItemCategory,
    bool? enableItemHsn,
    bool? enableItemDiscount,
    bool? enableItemMrp,
    num? quantityNotifier,
    num? priceNotifier,
  }) async {
    log("Updating settings with: Quantity: $quantityNotifier, Price: $priceNotifier");

    setLoadingValue(true);
    var data = {
      "enableItemCode": enableItemCode,
      "enableItemCategory": enableItemCategory,
      "enableItemHsn": enableItemHsn,
      "enableItemDiscount": enableItemDiscount,
      "enableItemMrp": enableItemMrp,
      "quantityDecimalPlaces": quantityNotifier,
      "commonDecimalPlaces": priceNotifier,
    };

    var response = await apiServices.putJsonData(
      authToken: await SharedPreLocalStorage.getToken(),
      endUrl: "settings/item",
      data: data,
    );

    log("Response from API: ${response?.statusCode} - $data");

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchSettingData();
        SnackBars.showSuccessSnackBar(text: "Successfully Setting Saved");
      }
    }
    setLoadingValue(false);
  }

  void updatedGstType({
    bool? isGst,
    bool? isVat,
    bool? enableItemCode,
    bool? enableItemCategory,
    bool? enableItemHsn,
    bool? enableItemDiscount,
    bool? enableItemMrp,
    num? quantityNotifier,
    num? priceNotifier,
  }) async {
    log("Updating settings with: Quantity: $quantityNotifier, Price: $priceNotifier");

    setLoadingValue(true);
    var data = {
      "gstTax": isGst,
      "vatTax": isVat,
    };

    var response = await apiServices.putJsonData(
      authToken: await SharedPreLocalStorage.getToken(),
      endUrl: "settings/item",
      data: data,
    );

    log("Response from API: ${response?.statusCode} - $data");

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        fetchSettingData();
        SnackBars.showSuccessSnackBar(text: "Successfully Setting Saved");
      }
    }
    setLoadingValue(false);
  }

  Future<void> fetchSettingData() async {
    setLoadingValue(true);

    var response = await apiServices.getRequest(
        authToken: await SharedPreLocalStorage.getToken(),
        endurl: EndUrl.itemSetting);
    log("item settings : $response");
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        settingModel.value = ItemSettingModel.fromJson(response.data);
        log("settings model \n settttings : ${settingModel.value}");
        if (settingModel.value.data != null) {
          Data? data = settingModel.value.data;
          gstTaxEnabled.value = data!.enableGstPercent ?? false;
          vatTaxEnabled.value = data.enableVatPercent ?? false;
          enableItemCode.value = data.enableItemCode ?? false;
          enableItemCategory.value = data.enableItemCategory ?? false;
          enableItemDiscount.value = data.enableItemDiscount ?? false;
          enableItemHsn.value = data.enableItemHsn ?? false;
          enableItemMrp.value = data.enableItemMrp ?? false;
          priceNotifier.value = data.commonDecimalPlaces ?? 1;
          quantityNotifier.value = data.quantityDecimalPlaces ?? 1;
        }
      }
    }
    setLoadingValue(false);
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchSettingData();
  }
}
