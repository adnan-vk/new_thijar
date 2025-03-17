import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/model/bank_details.dart';
import 'package:newthijar/model/bank_list_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/bank_detail_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class BankAccountsController extends GetxController {
  ApiServices apiServices = ApiServices();
  BankDetailsService bankDetailsService = BankDetailsService();
  RxList bankList = <BankListModel>[].obs;
  // RxList bankDetail = <BankDetails>[].obs;
  Rx<BankDetails?> bankDetail = Rx<BankDetails?>(null);
  var selectedItemCategory = 'All'.obs;
  var selectedStatus = 'Uncategorized'.obs;
  var selectedStock = 'In-Stock items'.obs;
  getBankList() async {
    try {
      bankList.clear();

      // Fetch response
      var response = await apiServices.getRequest(
        endurl: 'bank/',
        authToken: await SharedPreLocalStorage.getToken(),
      );

      // Log response for debugging
      log("Fetched response: $response");

      // Check if response and bankDetails exist
      if (response != null &&
          response.data != null &&
          response.data['data'] != null) {
        List jsonData = response.data['data'];

        // Map JSON data to the model list
        List<BankListModel> list = jsonData
            .map(
              (x) => BankListModel.fromJson(x),
            )
            .toList();

        bankList.addAll(list); // Add data to the observable list
      } else {
        log("Response data or bankDetails is null.");
      }
    } catch (e) {
      log("Error in stock summary controller: $e");
    }
  }

  getBankDetail(String bankId) async {
    try {
      // Fetch bank detail
      final response = await apiServices.getRequest(
        endurl: "bank/$bankId",
        authToken: await SharedPreLocalStorage.getToken(),
      );

      // Log response for debugging
      log("Fetched bank detail for ID $bankId: $response");

      // Check if response and bankDetails exist
      if (response != null &&
          response.data != null &&
          response.data['bankDetails'] != null) {
        bankDetail.value = BankDetails.fromJson(response.data['bankDetails']);
      } else {
        log("Bank detail data for ID $bankId is null.");
        bankDetail.value =
            null; // Reset observable to null if no data is available
      }
    } catch (e) {
      log("Error fetching bank details with ID $bankId: $e");
    }
  }
}
