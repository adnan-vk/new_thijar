import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class SyncAndShareService {
  final Dio _dio = Dio();

  Future<bool> addSyncCompany(
      Map<String, dynamic> companyData, authToken) async {
    const String apiUrl = "https://api.thijar.com/api/sync-share/add-user";
    var authToken = await SharedPreLocalStorage.getToken();
    try {
      final response = await _dio.post(
        apiUrl,
        data: companyData,
        options: Options(headers: {
          "Content-Type": "application/json",
          // Add the Authorization header
          "Authorization": "Bearer $authToken",
        }),
      );

      if (response.statusCode == 201) {
        log("Sync sended successfully: ${response.data}");
        return true;
      } else {
        log("Failed to Sync Company: ${response.data}");
        return false;
      }
    } catch (e) {
      log("Error occurred while Syncing the company: $e");
      return false;
    }
  }
}
