import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class AddCompanyService {
  final Dio _dio = Dio();

  Future<bool> addCompany(Map<String, dynamic> companyData, authToken) async {
    const String apiUrl = "https://api.thijar.com/api/company";
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
        debugPrint("Company created successfully: ${response.data}");
        return true;
      } else {
        debugPrint("Failed to create company: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred while adding company: $e");
      return false;
    }
  }

  Future<bool> syncOrUnsyncCompany(String companyId, String token) async {
    try {
      // API Call Logic
      final response = await _dio.post(
        'https://api.thijar.com/api/company/select-company',
        data: {'companyId': companyId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("company swithced response : $response");

      if (response.statusCode == 200) {
        final data = response.data;
        String token = data['token'];
        SharedPreLocalStorage.setToken(token);
        return true; // Indicate success
      }
      return false; // Indicate failure
    } catch (e) {
      log('Error in syncOrUnsyncCompany: $e');
      return false; // Handle failure gracefully
    }
  }
}
