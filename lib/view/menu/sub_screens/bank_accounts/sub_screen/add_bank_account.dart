import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newthijar/constants/colors.dart';
import 'package:newthijar/controller/add_edit_bank_controller.dart/add_edit_bank_controller.dart';
import 'package:newthijar/view/menu/sub_screens/bank_accounts/bank_accounts.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class AddBankAccount extends StatelessWidget {
  const AddBankAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final AddEditBankAccountController controller =
        Get.put(AddEditBankAccountController());
    return Scaffold(
      backgroundColor: Colorconst.cSecondaryGrey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: TopBar(
              page: "Add Bank Account",
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Column(
                        children: [
                          TextFormField(
                            controller: controller.accountNameContr,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: Colorconst
                                    .cBlack // Change this to your desired text color
                                ),
                            decoration: const InputDecoration(
                              labelText: "Bank Name/ Account Display Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 25.w),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller:
                                      controller.openingBalanceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: const TextStyle(
                                    color: Colorconst
                                        .cBlack, // Change this to your desired text color
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: "Opening Balance",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormField(
                                  controller: controller.dateController,
                                  style:
                                      const TextStyle(color: Colorconst.cBlack),
                                  decoration: const InputDecoration(
                                    labelText: "As On",
                                    suffixIcon: Icon(Icons.calendar_today),
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  onTap: () => controller.selectDate(
                                      context), // Use the controller's date picker
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.all(10.0.w),
                        color: Colorconst.cwhite,
                        child: Column(
                          children: [
                            Obx(() => ListTile(
                                  title: Text(
                                    "Print bank details on invoices",
                                    style: TextStyle(
                                        color: Colorconst.cBlack,
                                        fontSize: 14.sp),
                                  ),
                                  trailing: Switch(
                                    activeTrackColor:
                                        const Color.fromARGB(255, 6, 50, 115),
                                    value: controller.printBankDetails.value,
                                    onChanged: (bool value) {
                                      controller.printBankDetails.value = value;
                                    },
                                  ),
                                  leading: const Icon(Icons.info_outline),
                                )),
                            Obx(() => ListTile(
                                  title: Text(
                                    "Print UPI QR Code on invoices",
                                    style: TextStyle(
                                        color: Colorconst.cBlack,
                                        fontSize: 14.sp),
                                  ),
                                  trailing: Switch(
                                    activeTrackColor:
                                        const Color.fromARGB(255, 6, 50, 115),
                                    value: controller.printUPIQR.value,
                                    onChanged: (bool value) {
                                      controller.printUPIQR.value = value;
                                    },
                                  ),
                                  leading: const Icon(Icons.info_outline),
                                )),
                            Obx(() {
                              if (controller.printBankDetails.value) {
                                return Column(
                                  children: [
                                    SizedBox(height: 20.h),
                                    TextFormField(
                                      controller: controller.accountHolderCont,
                                      style: const TextStyle(
                                        color: Colorconst.cBlack,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "Account Holder Name",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    TextFormField(
                                      controller: controller.accountNumberCon,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: const TextStyle(
                                        color: Colorconst.cBlack,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "Account Number",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    TextFormField(
                                      controller: controller.ifscCodeController,
                                      style: const TextStyle(
                                        color: Colorconst.cBlack,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "IFSC Code",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    TextFormField(
                                      controller: controller.branchContr,
                                      style: const TextStyle(
                                        color: Colorconst.cBlack,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "Branch Name",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                            Obx(() {
                              if (controller.printUPIQR.value) {
                                return Column(
                                  children: [
                                    SizedBox(height: 20.h),
                                    TextFormField(
                                      controller: controller.upiIdOrqContr,
                                      style: const TextStyle(
                                        color: Colorconst.cBlack,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "UPI ID for QR Code",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: const Color.fromARGB(255, 6, 50, 115),
                  onPressed: () async {
                    // Save functionality
                    if (controller.saleValidator() == 'ok') {
                      await controller.addBankAccount();
                      // controller.clearControllers();
                      Get.to(() => const BankAccountsListPage());
                      // log("adding name : ${controller.accountNameContr.text}");
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              );
      }),
    );
  }
}
