import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:newthijar/model/edit_bank_model.dart';

class EditBankService {
  final Dio _dio = Dio();

  /// Edit a bank entry
  Future<void> editBank(String bankId, EditBankModel editBankModel) async {
    final url = "https://api.thijar.com/api/bank/$bankId";

    try {
      final response = await _dio.put(
        url,
        data: {
          "accountDisplayName": editBankModel.accountDisplayName,
          "openingBalance": editBankModel.openingBalance,
          "asOfDate": editBankModel.asOfDate?.toIso8601String(),
          "printUpiqrCodeOnInvoice": editBankModel.printUpiqrCodeOnInvoice,
          "printBankDetailsOnInvoice": editBankModel.printBankDetailsOnInvoice,
          "accountNumber": editBankModel.accountNumber,
          "ifscCode": editBankModel.ifscCode,
          "upiIdForQrCode": editBankModel.upiIdForQrCode,
          "branchName": editBankModel.branchName,
          "accountHolderName": editBankModel.accountHolderName,
        },
      );

      if (response.statusCode == 200) {
        log("Bank details updated successfully.");
      } else {
        log("Failed to update bank details: ${response.statusCode}");
      }
    } catch (e) {
      log("Error updating bank details: $e");
    }
  }

  /// Delete a bank entry
  Future<void> deleteBank(String bankId) async {
    final url = "https://api.thijar.com/api/bank/$bankId";

    try {
      final response = await _dio.delete(url);

      if (response.statusCode == 200) {
        log("Bank entry deleted successfully.");
      } else {
        log("Failed to delete bank entry: ${response.statusCode}");
      }
    } catch (e) {
      log("Error deleting bank entry: $e");
    }
  }
}
