import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class SharedWithMeService {
  final Dio _dio = Dio();

  Future<void> approveRequest(String id, {authToken}) async {
    const String url = "https://api.thijar.com/api/sync-share/approve-request";

    try {
      final response = await _dio.patch(
        url,
        options: Options(
          headers: {
            if (authToken != null) 'Authorization': 'Bearer $authToken',
          },
        ),
        data: {
          "requestId": id,
        },
      );

      if (response.statusCode == 200) {
        log("Request approved successfully: ${response.data}");
      } else {
        log("Failed to approve request: ${response.statusCode}");
      }
    } catch (e) {
      log("Error approving request: $e");
    }
  }

  Future<bool> switchCompany(String companyId, String token) async {
    try {
      // API Call Logic
      final response = await _dio.post(
        'http://3.110.41.88:8081/api/sync-share/select-company',
        data: {'companyId': companyId},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log("company swithced response : $response");

      if (response.statusCode == 200) {
        final data = response.data['data'];
        String token = data['token'];
        log("new tocken ====== $token");
        SharedPreLocalStorage.setToken(token);
        return true; // Indicate success
      }
      return false; // Indicate failure
    } catch (e) {
      log('Error in switchCompany: $e');
      return false; // Handle failure gracefully
    }
  }
}
