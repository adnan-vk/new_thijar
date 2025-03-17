import 'dart:developer';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/model/purchase_report_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class PurchaseReportController extends GetxController {
  ApiServices apiServices = ApiServices();
  RxList<PurchaseReportModel> allPurchase = <PurchaseReportModel>[].obs;
  var isLoading = false.obs;
  RxString totalPurchaseAmount = ''.obs;
  RxString balanceDue = ''.obs;
  List<List<String>> pdfDataList = [];
  final dateController = DateController();
  getPurchaseReport({
    String? transactionType,
    String? partyName,
    required DateFilterModel date,
  }) async {
    try {
      setLoadingValue(true);
      isLoading.value = true;
      allPurchase.clear();
      var endpoint =
          'reports/purchase?fromDate=${date.startDate}&toDate=${date.endDate}';
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

      totalPurchaseAmount.value = response!.data['totalAmount'].toString();
      balanceDue.value = response.data['balanceDue'].toString();
      List jsonData = response.data['TransactionList'];
      List<PurchaseReportModel> list =
          jsonData.map((x) => PurchaseReportModel.fromJson(x)).toList();

      log("${list.length}");
      allPurchase.addAll(list);

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
