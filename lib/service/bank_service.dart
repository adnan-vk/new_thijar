import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:newthijar/model/add_bank_model.dart';
import 'package:newthijar/service/api_service.dart';

class BankService {
  final ApiServices apiServices = ApiServices();

  Future addBank(AddBankModel bankModel, String authToken) async {
    log('Token for add bank: ${authToken.toString()}');
    try {
      // Check if the authToken is valid
      if (authToken.isEmpty) {
        log("Error: Authorization token is missing.");
        return;
      }
      log("${bankModel.toJson()}");

      var response = await apiServices.postJsonData(
          endUrl: "bank", data: bankModel.toJson(), authToken: authToken);

      if (response!.statusCode == 200 || response!.statusCode == 20) {
        log("Bank details added successfully: ${response!.data}");
      } else {
        log("Failed to add bank details: Status code ${response.statusCode}, Response: ${response.data}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Logging the status code and response data for better debugging
        log("Error adding bank details: Status code ${e.response?.statusCode}, Response: ${e.response?.data}");
      } else {
        // Log the error if there is no response
        log("Error sending request: $e");
      }
    } catch (e) {
      log("Unexpected error: $e");
    }
  }
}
