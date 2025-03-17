import 'dart:developer';

import 'package:get/get.dart';
import 'package:newthijar/model/sale_invoice_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';
import 'package:newthijar/widgets/snackbar/snackbar.dart';

class SaleInvoiceOrReportController extends GetxController {
  final ApiServices apiServices = ApiServices();
  RxList<SaleInvoiceModel> allSales = <SaleInvoiceModel>[].obs;
  var isLoading = false.obs;
  RxString totalSaleAmount = ''.obs;
  var pdfDataList = <List<String>>[].obs;
  // Existing method to fetch sales invoices
  Future<void> getSalesInvoice() async {
    try {
      setLoadingValue(true);

      var response = await apiServices.getRequest(
        endurl: 'invoice',
        authToken: await SharedPreLocalStorage.getToken(),
      );
      log("response ==${response}");
      setLoadingValue(false);
      totalSaleAmount.value = response!.data['totalSaleAmount'].toString();
      List jsonData = await response.data['data'];

      List<SaleInvoiceModel> list =
          jsonData.map((x) => SaleInvoiceModel.fromJson(x)).toList();
      allSales.assignAll(list);
      List<List<String>> tempList = [];
      for (int i = 0; i < list.length; i++) {
        SaleInvoiceModel obj = list[i];
        List<String> oneObj = [
          obj.invoiceDate.toString(),
          obj.invoiceNo.toString(),
          '-',
          obj.partyName.toString(),
          '-',
          '-',
          '-',
          obj.totalAmount.toString(),
          obj.paymentMethod.toString(),
          '-',
          obj.balanceAmount.toString(),
        ];
        tempList.add(oneObj);
      }
      pdfDataList.assignAll(tempList);
    } catch (e) {
      setLoadingValue(false);
      log("error in sales report controller $e");
    } finally {
      setLoadingValue(false);
    }
  }

  void searchSalesInvoice(String query) async {
    setLoadingValue(true);
    if (query.isEmpty) {
      await getSalesInvoice();
      return;
    }
    try {
      var response = await apiServices.getRequest(
        endurl: 'invoice?search=$query',
        authToken: await SharedPreLocalStorage.getToken(),
      );
      List jsonData = response!.data['data'];
      List<SaleInvoiceModel> list =
          jsonData.map((x) => SaleInvoiceModel.fromJson(x)).toList();
      allSales.assignAll(list);
      setLoadingValue(false);
    } catch (e) {
      setLoadingValue(false);
      log("Error in searchSalesInvoice: $e");
    } finally {
      setLoadingValue(false);
    }
  }

  void deleteSaleById({required String id}) async {
    setLoadingValue(true);

    var response = await apiServices.deleteRequest(
        endurl: EndUrl.invoiceUrl + id,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      setLoadingValue(false);
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        // final controller = Get.find<HomeController>();
        getSalesInvoice();
        Get.back();
        SnackBars.showSuccessSnackBar(text: "Deleted invoice");
      }
    }

    setLoadingValue(false);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //  getSalesInvoice();
  }
}
