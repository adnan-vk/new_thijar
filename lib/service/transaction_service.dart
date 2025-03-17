import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class TransactionService {
  final Dio _dio = Dio();

  Future<bool> addPrefix(Map<String, dynamic> prefix, authToken) async {
    const String apiUrl = "https://api.thijar.com/api/prefix";
    var authToken = await SharedPreLocalStorage.getToken();
    try {
      final response = await _dio.post(
        apiUrl,
        data: prefix,
        options: Options(headers: {
          "Content-Type": "application/json",
          // Add the Authorization header
          "Authorization": "Bearer $authToken",
        }),
      );

      if (response.statusCode == 200) {
        log("prefix added: ${response.data}");
        return true;
      } else {
        log("Failed to add prefix: ${response.data}");
        return false;
      }
    } catch (e) {
      log("Error occurred while adding Prefix: $e");
      return false;
    }
  }
}
