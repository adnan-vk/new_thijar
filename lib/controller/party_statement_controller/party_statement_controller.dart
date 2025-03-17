import 'dart:developer';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/model/customer_party_model.dart';
import 'package:newthijar/model/party_statement_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/urls/end_urls/end_urls.dart';
import 'package:newthijar/utils/is_respons_ok.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class PartyStatementController extends GetxController {
  // var searchQuery = ''.obs; // Reactive search query
  var showSuggestions = false.obs; // Control the visibility of suggestions
  var filteredResults = <String>[].obs; // Reactive list for filtered results
  ApiServices apiServices = ApiServices();
  RxList<PartyStatementModel> allStatement = <PartyStatementModel>[].obs;
  RxnNum totalAmount = RxnNum(0); // Reactive single number for total amount
  RxnNum closingBalance =
      RxnNum(0); // Reactive single number for closing balance

  // Sample search history
  // final List<String> searchHistory = [
  //   'Party 1',
  //   'Party 2',
  // ];

  RxList<CustomerPartyModelList> customerPartyNmList =
      <CustomerPartyModelList>[].obs;
  Rxn<CustomerPartyModelList> selectedCustomer = Rxn();

  // Method to filter results based on search query
  // void filterResults(String query) {
  //   searchQuery.value = query;
  //   if (query.isEmpty) {
  //     showSuggestions.value = false;
  //   } else {
  //     showSuggestions.value = true;
  //     filteredResults.value = searchHistory
  //         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }
  // }

  // Method to select a party and remove it from history
  // void selectParty(String selectedParty) {
  //   // searchQuery.value = selectedParty;
  //   showSuggestions.value = false;
  //   searchHistory.remove(selectedParty);
  // }

  Future<void> fetchCustomerParty() async {
    //  setLoadingValue(true);

    var response = await apiServices.getRequest(
        endurl: EndUrl.getAllParty,
        authToken: await SharedPreLocalStorage.getToken());

    if (response != null) {
      if (CheckRStatus.checkResStatus(statusCode: response.statusCode)) {
        var jsonResponse = response.data['data'];
        log("party names : $jsonResponse");
        List<CustomerPartyModelList> units = List<CustomerPartyModelList>.from(
            jsonResponse.map((x) => CustomerPartyModelList.fromJson(x)));

        customerPartyNmList.assignAll(units);
      }
    }
  }

  getPartyStatement({
    required DateFilterModel date,
  }) async {
    try {
      setLoadingValue(true);
      allStatement.clear();

      var response = await apiServices.getRequest(
        endurl:
            'reports/party/party-statement?fromDate=${date.startDate}&toDate=${date.endDate}&partyName=${selectedCustomer.value?.name}',
        authToken: await SharedPreLocalStorage.getToken(),
      );

      log("data in party statement : $response");

      setLoadingValue(false);

      // Update totalAmount and closingBalance as numbers
      totalAmount.value = response?.data['totalAmount'] ?? 0.0;
      closingBalance.value = response?.data['closingBalance'] ?? 0.0;

      // Update allStatement
      List jsonData = response?.data['data'] ?? [];
      List<PartyStatementModel> list =
          jsonData.map((x) => PartyStatementModel.fromJson(x)).toList();
      allStatement.addAll(list);
    } catch (e) {
      log("error in party statement controller $e");
      setLoadingValue(false); // Ensure loading is stopped on error
    }
  }
}
