// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newthijar/controller/date_controller/date_controller.dart';
import 'package:newthijar/controller/purchase_report_controller/purchase_report_controller.dart';
import 'package:newthijar/view/report/sub_screens/purchase_report/widgets/filter.dart';
import 'package:newthijar/view/report/sub_screens/purchase_report/widgets/widgets.dart';
import 'package:newthijar/view/top_bar/top_bar.dart';
import 'package:newthijar/widgets/report_date_widget/report_date_widget.dart';
import 'package:newthijar/widgets/text_style/text_style.dart';

class PurchaseReport extends StatelessWidget {
  PurchaseReport({super.key});
  DateController dateController = Get.put(DateController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseReportController());
    controller.getPurchaseReport(
        date: DateFilterModel(
            startDate: dateController.startDateIs.value,
            endDate: dateController.endDateIs.value));

    // Variables to store selected filters
    String selectedTxnType = "Purchase and Dr. Note";
    String selectedParty = "All Parties";
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 210,
            child: TopBar(
              page: "Purchase Report",
            ),
          ),
          Positioned(
            top: 160, // Adjust this to position the curved container correctly
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
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// **Modularized Date Filter Widget**
                    DateFilterWidget(
                      onCalendaerTap: () async {
                        DateFilterModel obj = await dateController
                            .selectDateRange(context, onSave: () {});
                        controller.getPurchaseReport(
                            date: DateFilterModel(
                                startDate: dateController.startDateIs.value,
                                endDate: dateController.endDateIs.value));
                      },
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                    ),

                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          "Filters Applied:",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        const Spacer(),
                        buildGradientButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => FilterDialog(
                                initialTxnType: selectedTxnType,
                                initialParty: selectedParty,
                              ),
                            ).then((selectedFilters) {
                              if (selectedFilters != null) {
                                log("Selected Filters: $selectedFilters");
                                selectedTxnType =
                                    selectedFilters['selectedTxnType'];
                                selectedParty =
                                    selectedFilters['selectedParty'];

                                final txnType = selectedTxnType == 'All'
                                    ? ''
                                    : selectedTxnType;
                                final partyName = selectedParty == 'All Parties'
                                    ? ''
                                    : selectedParty;

                                controller.getPurchaseReport(
                                  date: DateFilterModel(
                                      startDate:
                                          dateController.startDateIs.value,
                                      endDate: dateController.endDateIs.value),
                                  transactionType: txnType,
                                  partyName: partyName,
                                );
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    SizedBox(height: 12.h),

                    /// **Summary Cards**
                    Obx(
                      () => Row(
                        children: [
                          buildSummaryCard("No of Txns",
                              controller.allPurchase.length.toString()),
                          SizedBox(width: 8.w),
                          buildSummaryCard("Total Purchase",
                              controller.totalPurchaseAmount.value),
                          SizedBox(width: 8.w),
                          buildSummaryCard(
                              "Balance Due", controller.balanceDue.value),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => controller.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : controller.allPurchase.isEmpty
                                ? Center(
                                    child: Text(
                                      "No Data Available",
                                      style: interFontBlack(context),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: controller.allPurchase.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final item =
                                          controller.allPurchase[index];
                                      return TransactionCard(
                                        item: item,
                                      );
                                    },
                                  ),
                      ),
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
}
