import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:newthijar/controller/cahs_in_hand_controller/cash_in_hand_controller.dart';
import 'package:newthijar/model/cash_adjustment_list_model.dart';
import 'package:newthijar/view/menu/sub_screens/cash_in_hand/sub_screens/loading_screen.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/context_provider/context_provider.dart';
import 'package:newthijar/widgets/loading/loading.dart';

class CashInHand extends StatelessWidget {
  CashInHand({super.key});

  final CashInHandController controller = Get.put(CashInHandController());
  @override
  Widget build(BuildContext context) {
    controller.fetchCashInHands();
    return Scaffold(
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
            top: 145,
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
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        width: 400,
                        padding: const EdgeInsets.only(top: 25),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 30, 111, 191)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Current Cash Balance',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '₹ ${controller.currentCashBalance.value.toString()}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Transaction details (if any)
                    Obx(() {
                      if (isLoading.value == false &&
                          controller.cashInhandList.length.toInt() != 0) {
                        return Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Transaction Details',
                                    style: TextStyle(color: Colors.black)),
                                Text('Amount',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            const Divider(),
                            // Example transactions, replace with your actual data
                            SizedBox(
                              height: 420.h,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    controller.cashInhandList.length,
                                    (index) {
                                      var obj =
                                          controller.cashInhandList[index];

                                      return Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: transactionItem(
                                            context: context,
                                            model: obj,
                                            description: obj
                                                .createdBy!.businessName
                                                .toString(),
                                            amount: obj.amount.toString(),
                                            date:
                                                obj.adjustmentDate.toString()),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      } else {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/animation/cashinhand.json',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Hey! You have not added any cash transaction yet.\nAny transaction involving cash appears here.',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),

                    // const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => const LoadingScreen(),
                            ); // GetX navigation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 6, 50, 115)),
                            ),
                          ),
                          child: const Text(
                            'Bank Transfer',
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 50, 115)),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.clearTextController();
                            _showAdjustCashBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 6, 50, 115),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Adjust Cash',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionItem(
      {required String description,
      required String amount,
      CashAdjustMentListModel? model,
      context,
      required String date}) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              description,
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              amount,
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              date,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(
          height: 7.h,
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                // controller.clearTextController();
                _showEditAdjustCashBottomSheet(
                    context, model ?? CashAdjustMentListModel());
              },
              child: Icon(
                Icons.edit,
                size: 20.sp,
              ),
            ),
            SizedBox(
              width: 30.w,
            ),
            InkWell(
              onTap: () {
                showDeleteBottomSheet(id: model!.id.toString());
              },
              child: Icon(
                Icons.delete,
                size: 20.sp,
              ),
            ),
          ],
        )
      ],
    );
  }

  // Bottom sheet with radio buttons (converted to GetX)
  void _showAdjustCashBottomSheet(BuildContext context) {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      GetBuilder<CashInHandController>(
        builder: (controller) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adjust Cash',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => RadioListTile<int>(
                              activeColor:
                                  const Color.fromARGB(255, 6, 50, 115),
                              title: const Text(
                                'Add Cash',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: 1,
                              groupValue: controller.selectedRadioValue.value,
                              onChanged: (value) {
                                controller.setSelectedRadio(value!);
                              },
                            )),
                      ),
                      Expanded(
                        child: Obx(() => RadioListTile<int>(
                              activeColor:
                                  const Color.fromARGB(255, 6, 50, 115),
                              title: const Text(
                                'Reduce Cash',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: 2,
                              groupValue: controller.selectedRadioValue.value,
                              onChanged: (value) {
                                controller.setSelectedRadio(value!);
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      // Wait for the user to select a date
                      var date = await ContextProvider().selectDate(context);

                      if (date != null) {
                        try {
                          // Parse and format the selected date
                          DateTime parsedDate =
                              DateFormat("yyyy-MM-dd").parse(date);
                          String formattedDate =
                              DateFormat("yyyy-MM-dd").format(parsedDate);

                          // Update the controller with the formatted date
                          controller.adjustDateController.text = formattedDate;
                        } catch (e) {
                          log("Error parsing or formatting the date: $e");
                        }
                      } else {
                        log("No date was selected.");
                      }
                    },
                    child: TextField(
                      controller: controller.adjustDateController,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Enter Adjustment Date',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    controller: controller.amountController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Description(Optional)',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return Center(
                      child: isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (controller.isCashAdjustmentValidate()) {
                                  controller.addCash();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 6, 50, 115),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40),
                                child: Obx(() => Text(
                                    controller.selectedRadioValue.value == 1
                                        ? 'Add Cash'
                                        : 'Reduce Cash',
                                    style:
                                        const TextStyle(color: Colors.white))),
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showDeleteBottomSheet({required String id, String? title}) {
    Get.bottomSheet(Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.r)),
        height: 150.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                size: 35.sp,
                color: Colors.red,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        "Are you sure want to delete ?",
                        style:
                            TextStyle(color: Colors.black87, fontSize: 15.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Colors.blue),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 7.h),
                        child: Text(
                          "Cencel",
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.sp),
                        ),
                      ),
                    ),
                  ),
                  Obx(() {
                    return isLoading.value
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () {
                              controller.deleteCash(id: id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Colors.blue),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 7.h),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13.sp),
                                ),
                              ),
                            ),
                          );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void _showEditAdjustCashBottomSheet(
      BuildContext context, CashAdjustMentListModel model) {
    controller.adjustDateController.text = model.adjustmentDate.toString();
    controller.amountController.text = model.amount.toString();
    controller.descriptionController.text = model.description.toString();
    Get.bottomSheet(
      GetBuilder<CashInHandController>(
        builder: (controller) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Adjust Cash',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => RadioListTile<int>(
                              title: const Text(
                                'Add Cash',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: 1,
                              groupValue: controller.selectedRadioValue.value,
                              onChanged: (value) {
                                controller.setSelectedRadio(value!);
                              },
                            )),
                      ),
                      Expanded(
                        child: Obx(() => RadioListTile<int>(
                              title: const Text(
                                'Reduce Cash',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: 2,
                              groupValue: controller.selectedRadioValue.value,
                              onChanged: (value) {
                                controller.setSelectedRadio(value!);
                              },
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      var date = await ContextProvider().selectDate(context);

                      DateTime parsedDate =
                          DateFormat("MM/dd/yyyy").parse(date.toString());

                      String formattedDate =
                          DateFormat("yyyy-MM-dd").format(parsedDate);
                      controller.adjustDateController.text = formattedDate;
                    },
                    child: TextField(
                      controller: controller.adjustDateController,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      enabled: false,
                      decoration: const InputDecoration(
                          labelText: 'Enter Adjustment Date',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          disabledBorder: OutlineInputBorder()),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    controller: controller.amountController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Description(Optional)',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    return Center(
                      child: isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (controller.isCashAdjustmentValidate()) {
                                  controller.updateCash(
                                      id: model.id.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 40),
                                child: Obx(() => Text(
                                    controller.selectedRadioValue.value == 1
                                        ? 'Update Cash'
                                        : 'Update Cash',
                                    style:
                                        const TextStyle(color: Colors.white))),
                              ),
                            ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
