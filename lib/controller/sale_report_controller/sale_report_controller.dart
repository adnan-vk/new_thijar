import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/model/sale_report_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class SaleReportController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxList<SalesReportModel> allSales = <SalesReportModel>[].obs;
  var isLoading = false.obs;
  RxString totalSaleAmount = ''.obs;
  RxString totalTransactions = ''.obs;
  RxString balanceDue = ''.obs;
  List<List<String>> pdfDataList = [];
  final dateController = DateController();

  void getSalesReport({
    String? transactionType,
    String? partyName,
    required DateFilterModel date,
  }) async {
    log("Start date ==${date.startDate},,,${date.endDate}");
    try {
      setLoadingValue(true);
      isLoading.value = true;
      allSales.clear();
      var endpoint =
          'reports/sale?fromDate=${date.startDate}&toDate=${date.endDate}';
      if (transactionType != null && transactionType.isNotEmpty) {
        endpoint += '&transactionType=$transactionType';
      }
      if (partyName != null && partyName.isNotEmpty) {
        endpoint += '&partyName=$partyName';
      }
      var response = await apiServices.getRequest(
        endurl: endpoint,
        authToken: await SharedPreLocalStorage.getToken(),
      );

      setLoadingValue(false);

      totalSaleAmount.value = response!.data['totalAmount'].toString();
      totalTransactions.value = response.data['totalTransactions'].toString();
      balanceDue.value = response.data['balanceDue'].toString();
      List jsonData = response.data['TransactionList'];
      List<SalesReportModel> list =
          jsonData.map((x) => SalesReportModel.fromJson(x)).toList();

      log("${list.length}");
      allSales.addAll(list);

      // Populate PDF data
      List<List<String>> tempList = [];
      // for (var obj in list) {
      //   List<String> oneObj = [
      //     obj.transactionDate.toString(),
      //     obj.invoiceNo.toString(),
      //     '-',
      //     obj.party!.name.toString(),
      //     '-',
      //     '-',
      //     '-',
      //     obj.totalAmount.toString(),
      //     obj.paymentMethod.toString(),
      //     '-',
      //     obj.balance.toString(),
      //   ];
      //   tempList.add(oneObj);
      // }
      pdfDataList.assignAll(tempList);
    } catch (e) {
      log("error in sales report controller $e");
    } finally {
      isLoading.value = false;
    }
  }
}
