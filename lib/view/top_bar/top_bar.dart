// ignore_for_file: must_be_immutable

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/business_controller/business_controller.dart';
import 'package:newthijar/controller/home_controller/home_controller.dart';
import 'package:newthijar/urls/base_url.dart';
import 'package:newthijar/view/business_profile/business_profile.dart';
import 'package:newthijar/widgets/db/db.dart';

final businessController = Get.put(BusinessController());

class TopBar extends StatelessWidget {
  final Repository repository = Repository();
  String? balance;
  String? page;
  TopBar({super.key, this.balance, this.page});

  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.put(HomeController(repository: repository));
    businessController.fetchUserProfile();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 6, 50, 115),
            Color.fromARGB(255, 30, 111, 191)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar with Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  controller.busiNessProfileModel.value.businessProfile == null
                      ? "Wait..."
                      : controller.busiNessProfileModel.value.businessProfile!
                          .businessName
                          .toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.language, color: Colors.white),
                  const SizedBox(width: 10),
                  const Icon(EneftyIcons.notification_outline,
                      color: Colors.white),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const BusinessProfileScreen());
                    },
                    child: Obx(
                      () => CircleAvatar(
                          backgroundImage:
                              businessController.apiLogo.value.isNotEmpty
                                  ? NetworkImage(ApiBaseUrl.fileBaseUrl +
                                      businessController.apiLogo.value)
                                  : const AssetImage("assets/images/logo.jpg")),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (page == "Sale" ||
              page == "Add / Edit Item" ||
              page == "Add New Party" ||
              page == "Party Statement" ||
              page == "Sales Report" ||
              page == "Stock Detail Report" ||
              page == "Purchase Report" ||
              page == "Cashflow Report" ||
              page == "Item Settings" ||
              page == "Manage Companies" ||
              page == "Add User" ||
              page == "General Settings" ||
              page == "Settings" ||
              page == "Tax Settings" ||
              page == "Transaction Settings" ||
              page == "Manage Godowns" ||
              page == "Stock Transfer" ||
              page == "Add Units" ||
              page == "Bank Accounts List" ||
              page == "Add Bank Account" ||
              page == "Business Card" ||
              page == "Trial Balance" ||
              page == "Business Profile" ||
              page == "Purchase Bill" ||
              page == "Payment In" ||
              page == "Purchase Order" ||
              page == "Sale Order" ||
              page == "Estimate / Quotation" ||
              page == "Expense" ||
              page == "Sale Invoice" ||
              page == "Strock Transfer")
            Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            EneftyIcons.arrow_left_3_outline,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          page.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (page == "Sale")
                      Row(
                        children: [
                          const Text(
                            'Credit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50, // Adjust width to match the image
                            height: 30, // Adjust height to match the image
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Transform.scale(
                              scale:
                                  0.8, // Adjust scale to fit the container nicely
                              child: Switch(
                                value:
                                    false, // Change this to a variable if you need dynamic behavior
                                onChanged: (bool value) {
                                  // Handle toggle switch logic here
                                },
                                activeColor: Colors.white,
                                activeTrackColor:
                                    const Color.fromARGB(255, 6, 50, 115),
                                inactiveThumbColor:
                                    const Color.fromARGB(255, 6, 50, 115),
                                inactiveTrackColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Cash',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          if (page == "Report") const SizedBox(height: 20),

          // Reports Text
          if (page == "Report")
            const Text(
              'Reports',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

          if (page == "Menu") const SizedBox(height: 20),
          if (page == "Menu")
            // Big Bumper Sale Section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sale Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'BIG BUMPER SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'HURRY UP!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 6, 50, 115),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Promo Text
                  const Text(
                    'Now, become a Premium Thijar and get exclusive\n'
                    'Benefits At Up to 60% OFF.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          if (page == "Home") const SizedBox(height: 20),

          // Balance Section (if applicable)
          if (page == "Home")
            Center(
              child: Column(
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$$balance',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
