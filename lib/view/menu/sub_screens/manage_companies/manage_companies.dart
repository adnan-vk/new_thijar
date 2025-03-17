// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/add_company_controller/add_company_controller.dart';
import 'package:newthijar/controller/manage_company_controller/manage_company_controller.dart';
import 'package:newthijar/view/menu/sub_screens/manage_companies/sub_screens/create_company/create_company.dart';
import 'package:newthijar/view/menu/sub_screens/manage_companies/sub_screens/my_companies/my_companies.dart';
import 'package:newthijar/view/menu/sub_screens/manage_companies/sub_screens/shared_with_me/shared_with_me.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';

class ManageCompanies extends StatefulWidget {
  const ManageCompanies({super.key});

  @override
  _ManageCompaniesState createState() => _ManageCompaniesState();
}

final AddCompanyController addCompanyController =
    Get.put(AddCompanyController());

class _ManageCompaniesState extends State<ManageCompanies>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildBottomButtons(context),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 185,
            child: TopBar(
              page: "Manage Companies",
            ),
          ),
          Positioned(
            top: 155,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: TabBar(
                    controller: _tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: 3.0, color: Color.fromARGB(255, 6, 50, 115)),
                    ),
                    labelColor: const Color.fromARGB(255, 6, 50, 115),
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(
                        text: "My Companies",
                      ),
                      Tab(text: "Shared With Me"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      const MyCompanies(),
                      SharedWithMeScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomButtons(BuildContext context) {
    final ManageCompaniesController controller =
        Get.put(ManageCompaniesController());
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50, // Set height to match the image
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextButton(
              onPressed: controller.openFileManager,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.restore),
                  Text(
                    "Restore Backup",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50, // Set height to match the image
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 50, 115),
                  Color.fromARGB(255, 30, 111, 191)
                ], // Gradient blue
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: TextButton(
              onPressed: () {
                Get.to(const CreateCompanyScreen());
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    EneftyIcons.add_outline,
                    color: Colors.white,
                  ),
                  Text(
                    "Add Company",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
