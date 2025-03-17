import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:newthijar/model/bank_details.dart';

class BankDetailsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.thijar.com/api/bank",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  // Update Bank Details by ID
  Future<bool> updateBankDetails(String bankId, BankDetails bankDetails) async {
    try {
      final response = await _dio.put(
        '/$bankId',
        data: bankDetails.toJson(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        log("Failed to update bank details: ${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      log("Error occurred while updating bank details: ${e.message}");
      return false;
    }
  }
}
