import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/model/shaed_with_me_model.dart';
import 'package:newthijar/service/api_service.dart';
import 'package:newthijar/service/shared_with_me_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class SharedWithMeController extends GetxController {
  ApiServices apiServices = ApiServices();
  SharedWithMeService service = SharedWithMeService();
  RxList<SharedWithMeModel> allShareCompany = <SharedWithMeModel>[].obs;
  RxString selectedCompanyId = ''.obs;
  final RxMap<String, bool> joinStatus = <String, bool>{}.obs;

  void getSharedWithMe() async {
    try {
      setLoadingValue(true);
      isLoading.value = true;
      allShareCompany.clear();
      var endpoint = 'sync-share/shared-with-me';
      var response = await apiServices.getRequest(
        endurl: endpoint,
        authToken: await SharedPreLocalStorage.getToken(),
      );

      setLoadingValue(false);
      List jsonData = response!.data['pendingRequests'];
      log("response of shared with me : $response");
      List<SharedWithMeModel> list =
          jsonData.map((x) => SharedWithMeModel.fromJson(x)).toList();

      log("${list.length}");
      allShareCompany.addAll(list);
    } catch (e) {
      log("error in sales report controller $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveRequest(String id) async {
    try {
      await service.approveRequest(
        id,
        authToken: await SharedPreLocalStorage.getToken(),
      );
      Get.snackbar("Success", "Request approved successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to approve request: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> switchCompany(String companyId) async {
    try {
      // Check current sync status or assume false if not initialized
      final isCurrentlySynced = joinStatus[companyId] ?? false;

      // Call service to sync/unsync company
      final success = await service.switchCompany(
        companyId,
        await SharedPreLocalStorage.getToken(),
      );

      if (success) {
        // Toggle the sync status in the map
        joinStatus[companyId] = !isCurrentlySynced;
        joinStatus.refresh(); // Refresh the state
        // companyController.getCompanies();

        Get.snackbar(
          'Success',
          joinStatus[companyId]!
              ? 'Company synced successfully'
              : 'Company unsynced successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to ${isCurrentlySynced ? "unsync" : "sync"} the company. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      log('An unexpected error occurred: $e');
    }
  }
}
