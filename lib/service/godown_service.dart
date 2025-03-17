import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newthijar/model/godown_type_model.dart';
import 'package:newthijar/model/manage_godown_model.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class GodownService {
  final Dio _dio = Dio();
  static const String apiUrl = "https://api.thijar.com/api/godown";

  // Add a godown
  /* Future<bool> */ addGodown(Datas godownData) async {
    try {
      final authToken = await SharedPreLocalStorage.getToken();
      final response = await _dio.post(
        apiUrl,
        data: godownData.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $authToken",
          },
        ),
      );

      if (response.statusCode == 201) {
        debugPrint("Godown created successfully: ${response.data}");
        return true;
      } else {
        debugPrint("Failed to create Godown: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred while adding Godown: $e");
      return false;
    }
  }

  // Fetch all godowns
  fetchGodowns() async {
    try {
      final authToken = await SharedPreLocalStorage.getToken();
      final response = await _dio.get(
        apiUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",
          },
        ),
      );

      log("response of all godowns is : $response");

      if (response.statusCode == 200) {
        final List<dynamic> godownList = response.data["data"];
        return godownList.map((json) => Datas.fromJson(json)).toList();
      } else {
        log("Failed to fetch Godowns: ${response.data}");
        return [];
      }
    } catch (e) {
      log("Error occurred while fetching Godowns: $e");
      return [];
    }
  }

  fetchGodownsTypes() async {
    try {
      final authToken = await SharedPreLocalStorage.getToken();
      final response = await _dio.get(
        "https://api.thijar.com/api/godown/godown-types",
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",
          },
        ),
      );

      log("response of all godowns is : $response");

      if (response.statusCode == 200) {
        final List<dynamic> godownList = response.data["data"];
        return godownList
            .map((json) => GodownTypeModel.fromJson(json))
            .toList();
      } else {
        log("Failed to fetch Godowns: ${response.data}");
        return [];
      }
    } catch (e) {
      log("Error occurred while fetching Godowns: $e");
      return [];
    }
  }

  // Update a godown
  Future<bool> updateGodown(String id, Datas godownData) async {
    try {
      final authToken = await SharedPreLocalStorage.getToken();
      final response = await _dio.put(
        "$apiUrl/$id",
        data: godownData.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $authToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("Godown updated successfully: ${response.data}");
        return true;
      } else {
        debugPrint("Failed to update Godown: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred while updating Godown: $e");
      return false;
    }
  }

  // Delete a godown
  Future<bool> deleteGodown(String id) async {
    try {
      final authToken = await SharedPreLocalStorage.getToken();
      final response = await _dio.delete(
        "$apiUrl/$id",
        options: Options(
          headers: {
            "Authorization": "Bearer $authToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        debugPrint("Godown deleted successfully: ${response.data}");
        return true;
      } else {
        debugPrint("Failed to delete Godown: ${response.data}");
        return false;
      }
    } catch (e) {
      debugPrint("Error occurred while deleting Godown: $e");
      return false;
    }
  }
}
