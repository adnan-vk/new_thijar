import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/company_controller/company_controller.dart';
import 'package:newthijar/model/add_company_model.dart';
import 'package:newthijar/service/add_comany_service.dart';
import 'package:newthijar/shared_preference/shared_preference.dart';

class AddCompanyController extends GetxController {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();

  final AddCompanyService _service = AddCompanyService();
  final CompanyController companyController = Get.put(CompanyController());
  // Map to track sync status for each company
  final RxMap<String, bool> syncStatus = <String, bool>{}.obs;

  /// Submit company details
  void submitCompanyDetails() async {
    final company = AddCompanyModel(
      companyName: businessNameController.text.trim(),
      phoneNo: phoneNumberController.text.trim(),
      email: emailIdController.text.trim(),
    );

    if (company.companyName!.isEmpty ||
        company.phoneNo!.isEmpty ||
        company.email!.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final isSuccess = await _service.addCompany(
      company.toJson(),
      await SharedPreLocalStorage.getToken(),
    );

    if (isSuccess) {
      Get.back();
      Get.snackbar(
        "Success",
        "Company added successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      clearFields();
    } else {
      Get.snackbar(
        "Error",
        "Failed to add company. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Clear form fields
  void clearFields() {
    businessNameController.clear();
    phoneNumberController.clear();
    emailIdController.clear();
  }

  /// Sync or Unsync Company
  Future<void> syncOrUnsyncCompany(String companyId) async {
    try {
      // Check current sync status or assume false if not initialized
      final isCurrentlySynced = syncStatus[companyId] ?? false;

      // Call service to sync/unsync company
      final success = await _service.syncOrUnsyncCompany(
        companyId,
        await SharedPreLocalStorage.getToken(),
      );

      if (success) {
        // Toggle the sync status in the map
        syncStatus[companyId] = !isCurrentlySynced;
        syncStatus.refresh(); // Refresh the state
        companyController.getCompanies();

        Get.snackbar(
          'Success',
          syncStatus[companyId]!
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
