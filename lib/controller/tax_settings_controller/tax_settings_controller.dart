import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/model/tax_settings_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class TaxSettingController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxBool gstTaxEnabled = false.obs;
  RxBool vatTaxEnabled = false.obs;
  RxBool enableEInvoice = false.obs;
  RxBool enableEWayBill = false.obs;
  RxBool enableMyOnlineStore = false.obs;

  Rx<TaxSettingModel> settingModel = TaxSettingModel().obs;

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
      enableEInvoice: enableEInvoice.value,
      enableEWayBill: enableEWayBill.value,
      enableMyOnlineStore: enableMyOnlineStore.value,
    );
  }

  updatedItemSettings({
    bool? enableMyOnlineStore,
    bool? enableEWayBill,
    bool? enableEInvoice,
  }) async {
    log("my online : $enableMyOnlineStore  -- e way bill  : $enableEWayBill  --  e invoice : $enableEInvoice");
    setLoadingValue(true);
    var data = {
      "enableEInvoice": enableEInvoice,
      "enableMyOnlineStore": enableMyOnlineStore,
      "enableEWayBill": enableEWayBill,
    };

    var response = await apiServices.putJsonData(
      authToken: await SharedPreLocalStorage.getToken(),
      endUrl: "settings/tax",
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
  }) async {
    log("Updating Gst: $isGst, Vat: $isVat");

    setLoadingValue(true);
    var data = {
      "gstTax": isGst,
      "vatTax": isVat,
    };

    var response = await apiServices.putJsonData(
      authToken: await SharedPreLocalStorage.getToken(),
      endUrl: "settings/tax",
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
        endurl: "settings/tax");
    log("Tax settings : $response");
    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        settingModel.value = TaxSettingModel.fromJson(response.data);
        log("settings model \n settttings : ${settingModel.value}");
        if (settingModel.value.data != null) {
          Data? data = settingModel.value.data;
          gstTaxEnabled.value = data!.enableGstPercent ?? false;
          vatTaxEnabled.value = data.enableVatPercent ?? false;
          enableEInvoice.value = data.enableEInvoice ?? false;
          enableEWayBill.value = data.enableEWayBill ?? false;
          enableMyOnlineStore.value = data.enableMyOnlineStore ?? false;
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
