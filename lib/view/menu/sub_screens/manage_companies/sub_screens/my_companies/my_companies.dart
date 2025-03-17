import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/add_company_controller/add_company_controller.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/company_controller/company_controller.dart';
import 'package:newthijar/view/menu/sub_screens/manage_companies/sub_screens/my_companies/widgets/widgets.dart';

class MyCompanies extends StatefulWidget {
  const MyCompanies({super.key});

  @override
  State<MyCompanies> createState() => _MyCompaniesState();
}

final CompanyController companyController = Get.put(CompanyController());
final businessController = Get.put(BusinessController());

class _MyCompaniesState extends State<MyCompanies> {
  final AddCompanyController addCompanyController =
      Get.put(AddCompanyController());

  @override
  Widget build(BuildContext context) {
    companyController.getCompanies();
    businessController.fetchUserProfile();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (companyController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (companyController.companyData.isEmpty) {
          return const Center(child: Text("No companies available."));
        }

        return SingleChildScrollView(
          child: Column(
            children: List.generate(
              companyController.companyData.length,
              (index) => Column(
                children: [
                  // buildCompanyCard(
                  //   context,
                  //   companyController.companyData[index],
                  // ),
                  CompanyCard(
                    company: companyController.companyData[index],
                  ),
                  Divider(color: Colors.grey.shade300, thickness: 1),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
